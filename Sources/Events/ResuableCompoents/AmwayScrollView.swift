//
//  AmwayScrollView.swift
//
// Copyright © 2021 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

// It is used generic ViewBuilder pattern for content
struct AmwayScrollView<Content: View>: UIViewRepresentable {
    var width: CGFloat
    var height: CGFloat
    var refreshControlViewData: AmwayRefreshControlBuilder.AmwayRefreshControlData
    var refreshAction: (() -> Void)?
    let content: () -> Content

    public init(width: CGFloat,
                height: CGFloat,
                refreshControlViewData: AmwayRefreshControlBuilder.AmwayRefreshControlData = AmwayRefreshControlBuilder().build(),
                refreshAction: (() -> Void)?,
                @ViewBuilder content: @escaping () -> Content)
    {
        self.width = width
        self.height = height
        self.refreshControlViewData = refreshControlViewData
        self.refreshAction = refreshAction
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.delegate = context.coordinator
        let refreshControl = AmwayRefreshControl()
        refreshControl.data = refreshControlViewData
        control.refreshControl = refreshControl
        control.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl), for: .valueChanged)

        let childView = UIHostingController(rootView: content())
        childView.view.backgroundColor = .clear

        childView.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        control.addSubview(childView.view)
        return control
    }

    func updateUIView(_: UIScrollView, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension AmwayScrollView {
    class Coordinator: NSObject, UIScrollViewDelegate {
        var control: AmwayScrollView<Content>

        init(_ control: AmwayScrollView) {
            self.control = control
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            sender.endRefreshing()
            control.refreshAction?()
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let refreshControl = scrollView.refreshControl as? AmwayRefreshControl else {
                return
            }
            refreshControl.updateProgress(with: scrollView.contentOffset.y + (scrollView.parentView?.safeAreaLayoutGuide.layoutFrame.minY ?? 0.0))
        }
    }
}
