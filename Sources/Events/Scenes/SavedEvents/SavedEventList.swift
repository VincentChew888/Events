//
//  SavedEventList.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct SavedEventList: View {
    var savedEvents: [SavedEventsData]
    var headerTitle: String
    let didTapSaveButton: (SavedEventsData) -> Void
    let analyticsEventCompletion: SavedEventsView.AnalyticsEventCompletion
    let didTapEvent: (String) -> Void

    private enum Constants {
        static let xpadding: CGFloat = 16
        static let height: CGFloat = 32
        static let padding: CGFloat = 8
    }

    var body: some View {
        List {
            Section(header: SaveListHeader(title: headerTitle)) {
                ForEach(savedEvents) { event in
                    SavedEventCell(event: event,
                                   didTapSaveButton: didTapSaveButton,
                                   analyticsEventCompletion: analyticsEventCompletion,
                                   didTapEvent: didTapEvent)
                }
            }.textCase(nil)
                .listRowInsets(EdgeInsets(top: Constants.height, leading: Constants.xpadding, bottom: Constants.padding, trailing: Constants.xpadding))
        }
        .introspectTableView { tableView in
            tableView.backgroundColor = .clear
        }
        .listStyle(GroupedListStyle())
        .background(Theme.current.backgroundGray.color)
    }
}

struct SaveListHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .foregroundColor(Theme.current.amwayBlack.color)
            .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont, lineHeight: Theme.current.bodyOneBold.lineHeight, verticalPadding: 0)
            .accessibilityIdentifier(AutomationControl.savedEventsSectionHeader.rawValue)
    }
}

// MARK: - Accessibility

private extension SaveListHeader {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case savedEventsSectionHeader
    }
}
