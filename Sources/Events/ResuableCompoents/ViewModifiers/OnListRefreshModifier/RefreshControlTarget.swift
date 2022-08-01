//
//  RefreshControlTarget.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import UIKit

final class RefreshControlTarget: NSObject, ObservableObject {
    // MARK: - Instance properties

    private var contentOffsetObserver: NSKeyValueObservation?
    private var onValueChanged: ((_ refreshControl: UIRefreshControl) -> Void)?

    // MARK: - Public methods

    func addRefreshControl(on scrollView: UIScrollView,
                           refreshControlData: AmwayRefreshControlBuilder.AmwayRefreshControlData = AmwayRefreshControlBuilder().build(),
                           onValueChanged: @escaping ((UIRefreshControl) -> Void))
    {
        observeContentOffset(scrollView)

        if scrollView.refreshControl != nil {
            scrollView.refreshControl?.endRefreshing()
            scrollView.refreshControl = nil
        }

        scrollView.refreshControl = createRefreshControl(refreshControlData)

        self.onValueChanged = onValueChanged
    }
}

// MARK: - Private methods

private extension RefreshControlTarget {
    private func observeContentOffset(_ scrollView: UIScrollView) {
        contentOffsetObserver = scrollView.observe(\.contentOffset,
                                                   options: .new) { _, _ in

            guard let refreshControl = scrollView.refreshControl as? AmwayRefreshControl,
                  let view = scrollView.parentView
            else {
                return
            }
            refreshControl.updateProgress(with: scrollView.contentOffset.y + view.safeAreaLayoutGuide.layoutFrame.minY)
        }
    }

    private func createRefreshControl(_ refreshControlData: AmwayRefreshControlBuilder.AmwayRefreshControlData) -> AmwayRefreshControl {
        let refreshControl = AmwayRefreshControl()
        refreshControl.data = refreshControlData
        refreshControl.addTarget(self,
                                 action: #selector(onValueChangedAction),
                                 for: .valueChanged)
        return refreshControl
    }

    @objc private func onValueChangedAction(sender: UIRefreshControl) {
        onValueChanged?(sender)
    }
}
