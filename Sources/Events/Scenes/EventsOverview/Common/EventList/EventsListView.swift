//
//  EventsListView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import Introspect
import SwiftUI

struct EventsListView: View {
    var eventsSections: [EventsSection]
    let didTapEvent: (String) -> Void
    let analyticsEventCompletion: EventsOverviewView.AnalyticsEventCompletion

    @State private var contentOffsetTarget = ContentOffsetTarget()
    @Binding private var topSectionStartOfMonth: Date
    let didTapSaveButton: (EventsData) -> Void
    @State private var isScrollInProgress = false

    private enum Constants {
        static let xpadding: CGFloat = 16
        static let emptyEventBottom: CGFloat = 8
        static let firstItemTop: CGFloat = 32
        static let height: CGFloat = 0
    }

    init(eventsSections: [EventsSection],
         topSectionStartOfMonth: Binding<Date>,
         didTapEvent: @escaping (String) -> Void,
         didTapSaveButton: @escaping (EventsData) -> Void,
         analyticsEventCompletion: @escaping EventsOverviewView.AnalyticsEventCompletion)
    {
        self.eventsSections = eventsSections
        _topSectionStartOfMonth = topSectionStartOfMonth
        self.didTapEvent = didTapEvent
        self.didTapSaveButton = didTapSaveButton
        self.analyticsEventCompletion = analyticsEventCompletion
        UITableView.appearance(whenContainedInInstancesOf: [UIHostingController<EventsOverviewView>.self]).backgroundColor = Theme.current.backgroundGray.uiColor
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(eventsSections) { section in
                    let topPadding: CGFloat = section == eventsSections.first ? Constants.firstItemTop : Constants.xpadding
                    let bottomPadding: CGFloat = section.events.isEmpty ? Constants.emptyEventBottom : Constants.xpadding

                    Section(header: ListHeader(title: section.title,
                                               noEvents: section.events.isEmpty)
                            .padding(.bottom, bottomPadding)
                            .padding(.top, topPadding)
                    ) {
                        if section.events.isEmpty {
                            EmptyCell()
                                .padding(.vertical, 1)
                                .if(.iOS14) { view in
                                    view.padding(.vertical, CGFloat.leastNonzeroMagnitude)
                                }
                                .background(Theme.current.backgroundGray.color)
                                .listRowInsets(EdgeInsets(top: 0,
                                                          leading: 0,
                                                          bottom: -1,
                                                          trailing: 0))

                        } else {
                            ForEach(section.events) { event in
                                EventListCell(event: event,
                                              didTapEvent: didTapEvent,
                                              didTapSaveButton: didTapSaveButton,
                                              analyticsEventCompletion: analyticsEventCompletion)
                            }
                        }
                    }
                    .textCase(nil)
                    .listRowInsets(EdgeInsets(top: 0, leading: Constants.xpadding, bottom: 0, trailing: Constants.xpadding))
                }
            }
            .if(.iOS14) { view in
                view.onAppear(perform: {
                    UITableView.appearance(whenContainedInInstancesOf: [UIHostingController<EventsOverviewView>.self]).tableHeaderView
                        = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Constants.height))
                })
                .listStyle(GroupedListStyle())
            }
            .introspectTableView { tableView in
                observeContentOffset(tableView: tableView)
            }
            .listStyle(GroupedListStyle())
            .background(Theme.current.backgroundGray.color)
            .environment(\.defaultMinListRowHeight, 0)
            .navigationBarColor(backgroundColor: Theme.current.darkPurple.uiColor,
                                textColor: Theme.current.amwayWhite.uiColor)
            .onReceive(NotificationCenter.default.publisher(for: CustomNotification.eventsOverviewSegmentChange.name)) { data in
                guard let newValue = data.userInfo?[CustomNotification.UserInfoKeys.segmentChangeData] as? Date else { return }
                let sectionToBeScrolled = eventsSections.first { $0.date.startOfMonth() == newValue }
                guard let sectionToBeScrolled = sectionToBeScrolled else { return }

                isScrollInProgress = true
                scrollTo(section: sectionToBeScrolled,
                         scrollViewProxy: proxy)
            }
            .onDisappear {
                contentOffsetTarget.contentOffsetObserver = nil
            }
        }
    }

    private func observeContentOffset(tableView: UITableView) {
        contentOffsetTarget.contentOffsetObserver = tableView
            .observe(\UITableView.contentOffset,
                     options: [.old, .new]) { _, change in
                guard change.newValue != change.oldValue else { return }

                handleContentOffsetChange(tableView: tableView)
            }
    }

    /// Method to set the topSectionStartOfMonth binding property with the top section's startOfMonth() value of the List. This updates the Month Selector to the segment whose month matches the topSectionStartOfMonth value.
    private func handleContentOffsetChange(tableView: UITableView) {
        let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first
        let firstVisibleSection = firstVisibleIndexPath?.section

        // !isScrollInProgress: On tap of segments, list will be scrolled to particular section.
        // In this scenario We should not update 'topSectionStartOfMonth' binding property to avoid updating selected segment.
        guard !isScrollInProgress,
              let firstVisibleSection = firstVisibleSection,
              let sectionStartOfMonth = eventsSections[firstVisibleSection].date.startOfMonth(),
              topSectionStartOfMonth != sectionStartOfMonth else { return }

        topSectionStartOfMonth = sectionStartOfMonth
    }

    private func scrollTo(section: EventsSection, scrollViewProxy: ScrollViewProxy) {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy.scrollTo(section.id,
                                     anchor: .top)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isScrollInProgress = false
        }
    }
}

struct ListHeader: View {
    let title: String
    let noEvents: Bool

    var body: some View {
        Text(title)
            .foregroundColor(noEvents ? Theme.current.gray5.color : Theme.current.amwayBlack.color)
            .if(.iOS14) { view in
                view
                    .font(Theme.current.bodyOneBold.font)
                    .lineSpacing(Theme.current.bodyOneBold.lineHeight)
            }
            .if(.iOS15AndAbove) { view in
                view
                    .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                        lineHeight: Theme.current.bodyOneBold.lineHeight,
                                        verticalPadding: 0)
                    .frame(alignment: .center)
            }
            .accessibilityIdentifier(AutomationControl.eventsListSectionHeader.accessibilityIdentifier())
    }
}

// MARK: - Accessibility

private extension ListHeader {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case eventsListSectionHeader
    }
}

// MARK: - ContentOffsetTarget

final class ContentOffsetTarget: NSObject, ObservableObject {
    var contentOffsetObserver: NSKeyValueObservation?
}

class EmptyTVCell: UITableViewCell {
    init() {
        super.init(style: .default, reuseIdentifier: "")
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct EmptyCell: UIViewRepresentable {
    func makeUIView(context _: Context) -> some EmptyTVCell {
        EmptyTVCell()
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}
