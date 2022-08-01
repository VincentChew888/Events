//
//  SegmentListView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct SegmentListView: View {
    @Binding private var topSectionStartOfMonth: Date
    private let viewData: SegmentListViewBuilder.ViewData

    @State private var selectedIndex: Int = 0

    init(viewData: SegmentListViewBuilder.ViewData,
         topSectionStartOfMonth: Binding<Date>)
    {
        self.viewData = viewData
        _topSectionStartOfMonth = topSectionStartOfMonth
    }

    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollViewProxy in
                    HStack(alignment: .center, spacing: viewData.segmentSpacing) {
                        let count = viewData.segmentsData.count
                        ForEach(0 ..< count, id: \.self) { index in
                            let isSelected = index == selectedIndex
                            let viewData = SegmentView
                                .ViewData(title: viewData.segmentsData[index].title,
                                          colors: viewData.colors,
                                          fonts: viewData.fonts,
                                          segmentTitleLineHeight: viewData.segmentTitleLineHeight,
                                          isSelected: isSelected)
                            SegmentView(viewData: viewData)
                                .accessibilityIdentifier(isSelected
                                    ? AutomationControl.selectedMonth.accessibilityIdentifier(suffix: "\(index)")
                                    : AutomationControl.month.accessibilityIdentifier(suffix: "\(index)"))
                                .onTapGesture {
                                    self.selectedIndex = index
                                    let userInfoDict: [String: Any]
                                    userInfoDict = [CustomNotification.UserInfoKeys.segmentChangeData: self.viewData.segmentsData[index].startOfMonth]
                                    NotificationCenter.default.post(name: CustomNotification.eventsOverviewSegmentChange.name,
                                                                    object: nil,
                                                                    userInfo: userInfoDict)
                                    scrollTo(index: index,
                                             scrollViewProxy: scrollViewProxy)
                                }
                                .onChange(of: topSectionStartOfMonth) { newValue in
                                    let index = self.viewData.segmentsData.firstIndex { $0.startOfMonth == newValue }
                                    guard self.selectedIndex != index,
                                          let index = index else { return }

                                    self.selectedIndex = index
                                    scrollTo(index: index,
                                             scrollViewProxy: scrollViewProxy)
                                }
                        }
                    }
                    .padding(viewData.contentInsets)
                }
            }
        }
    }

    private func scrollTo(index: Int, scrollViewProxy: ScrollViewProxy) {
        withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy.scrollTo(index,
                                     anchor: .center)
        }
    }
}

// MARK: - Accessibility

private extension SegmentListView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case month
        case selectedMonth
    }
}
