//
//  RefreshableScrollView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

// There are two type of positioning views - one that scrolls with the content,
// and one that stays fixed
private enum PositionType {
    case fixed, moving
}

// This struct is the currency of the Preferences, and has a type
// (fixed or moving) and the actual Y-axis value.
// It's Equatable because Swift requires it to be.
private struct Position: Equatable {
    let type: PositionType
    let yPosition: CGFloat
}

// This might seem weird, but it's necessary due to the funny nature of
// how Preferences work. We can't just store the last position and merge
// it with the next one - instead we have a queue of all the latest positions.
private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]

    static var defaultValue = [Position]()

    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType

    var body: some View {
        GeometryReader { proxy in
            // the View itself is an invisible Shape that fills as much as possible
            Color.clear
                // Compute the top Y position and emit it to the Preferences queue
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, yPosition: proxy.frame(in: .global).minY)])
        }
    }
}

// Callback that'll trigger once refreshing is done
public typealias RefreshComplete = () -> Void

// The actual refresh action that's called once refreshing starts. It has the
// RefreshComplete callback to let the refresh action let the View know
// once it's done refreshing.
public typealias OnRefresh = (@escaping RefreshComplete) -> Void

// The offset threshold. 68 is a good number, but you can play
// with it to your liking.
public let defaultRefreshThreshold: CGFloat = 68

public let defaultLoaderOffset: CGFloat = 0

public let loaderWidth: CGFloat = 24
public let loaderHeight: CGFloat = 24

// Tracks the state of the RefreshableScrollView - it's either:
// 1. waiting for a scroll to happen
// 2. has been primed by pulling down beyond THRESHOLD
// 3. is doing the refreshing.
public enum RefreshState {
    case waiting, primed, loading
}

// ViewBuilder for the custom progress View, that may render itself
// based on the current RefreshState.
public typealias RefreshProgressBuilder<Progress: View> = (RefreshState) -> Progress

// Default color of the rectangle behind the progress spinner
public let defaultLoadingViewBackgroundColor = Color.clear

struct RefreshableScrollView<Progress, Content>: View where Progress: View, Content: View {
    private let showsIndicators: Bool // if the ScrollView should show indicators
    private let loadingViewBackgroundColor: Color
    private let threshold: CGFloat // what height do you have to pull down to trigger the refresh
    private let loaderOffset: CGFloat // loader offset
    private let onRefresh: OnRefresh // the refreshing action
    private let progress: RefreshProgressBuilder<Progress> // custom progress view
    private let content: () -> Content // the ScrollView content
    @State private var offset: CGFloat = 0
    @State private var state = RefreshState.waiting // the current state

    private let feedbackGenerator = UINotificationFeedbackGenerator() // haptic feedback

    // We use a custom constructor to allow for usage of a @ViewBuilder for the content
    public init(showsIndicators: Bool = true,
                loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
                threshold: CGFloat = defaultRefreshThreshold,
                loaderOffset: CGFloat = defaultLoaderOffset,
                onRefresh: @escaping OnRefresh,
                @ViewBuilder progress: @escaping RefreshProgressBuilder<Progress>,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.showsIndicators = showsIndicators
        self.loadingViewBackgroundColor = loadingViewBackgroundColor
        self.threshold = threshold
        self.onRefresh = onRefresh
        self.progress = progress
        self.content = content
        self.loaderOffset = loaderOffset
    }

    public var body: some View {
        // The root view is a regular ScrollView
        ScrollView(showsIndicators: showsIndicators) {
            // The ZStack allows us to position the PositionIndicator,
            // the content and the loading view, all on top of each other.
            ZStack(alignment: .top) {
                // The moving positioning indicator, that sits at the top
                // of the ScrollView and scrolls down with the content
                PositionIndicator(type: .moving)
                    .frame(height: 0)

                // Your ScrollView content. If we're loading, we want
                // to keep it below the loading view, hence the alignmentGuide.
                content()
                    .alignmentGuide(.top, computeValue: { _ in
                        (state == .loading) ? -threshold + offset : 0
                    })

                // The loading view. It's offset to the top of the content unless we're loading.
                ZStack {
                    Rectangle()
                        .foregroundColor(loadingViewBackgroundColor)
                        .frame(height: threshold)
                    progress(state)
                        .frame(width: loaderWidth, height: loaderHeight, alignment: .center)
                        .offset(y: loaderOffset)
                }.offset(y: (state == .loading) ? -offset : -threshold)
            }
        }
        // Put a fixed PositionIndicator in the background so that we have
        // a reference point to compute the scroll offset.
        .background(PositionIndicator(type: .fixed))
        // Once the scrolling offset changes, we want to see if there should
        // be a state change.
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            // Compute the offset between the moving and fixed PositionIndicators
            let movingY = values.first { $0.type == .moving }?.yPosition ?? 0
            let fixedY = values.first { $0.type == .fixed }?.yPosition ?? 0
            offset = movingY - fixedY
            if state != .loading { // If we're already loading, ignore everything
                // Map the preference change action to the UI thread
                DispatchQueue.main.async {
                    // If the user pulled down below the threshold, prime the view
                    if offset > threshold, state == .waiting {
                        state = .primed
                        self.feedbackGenerator.notificationOccurred(.success)

                        // If the view is primed and we've crossed the threshold again on the
                        // way back, trigger the refresh
                    } else if offset < threshold, state == .primed {
                        state = .loading
                        onRefresh { // trigger the refreshing callback
                            // once refreshing is done, smoothly move the loading view
                            // back to the offset position
                            withAnimation {
                                self.state = .waiting
                            }
                        }
                    }
                }
            }
        }
    }
}

// Extension that uses default RefreshActivityIndicator so that you don't have to
// specify it every time.
extension RefreshableScrollView where Progress == RefreshActivityIndicator {
    init(showsIndicators: Bool = true,
         loadingViewBackgroundColor: Color = defaultLoadingViewBackgroundColor,
         threshold: CGFloat = defaultRefreshThreshold,
         loaderOffset: CGFloat = defaultLoaderOffset,
         onRefresh: @escaping OnRefresh,
         @ViewBuilder content: @escaping () -> Content)
    {
        self.init(showsIndicators: showsIndicators,
                  loadingViewBackgroundColor: loadingViewBackgroundColor,
                  threshold: threshold,
                  loaderOffset: loaderOffset,
                  onRefresh: onRefresh,
                  progress: { state in
                      RefreshActivityIndicator(isAnimating: state == .loading)
                  },
                  content: content)
    }
}

// Wraps a CircularLoadingView as a loading spinner.
struct RefreshActivityIndicator: UIViewRepresentable {
    typealias UIView = CircularLoadingView
    var isAnimating: Bool = true

    init(isAnimating: Bool) {
        self.isAnimating = isAnimating
    }

    func makeUIView(context _: UIViewRepresentableContext<Self>) -> UIView {
        let view = UIView()
        view.bounds.size = CGSize(width: loaderWidth, height: loaderHeight)
        view.data = CircularLoadingViewBuilder().build()
        return view
    }

    func updateUIView(_ uiView: UIView, context _: UIViewRepresentableContext<Self>) {
        uiView.isAnimating = isAnimating
    }
}
