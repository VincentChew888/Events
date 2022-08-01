//
//  EventDetailSection.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//
import AmwayThemeKit
import SwiftUI

struct EventDetailSection: View {
    // MARK: - View Dependencies

    let eventsDetailSectionTitle: String
    var eventDetailSection: [EventDetailCell.ViewData]
    let didTapOnContentButton: (EventDetailCell.ActionType?) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 19.0) {
            sectionTitle
            VStack(alignment: .leading, spacing: 16.0) {
                ForEach(eventDetailSection) { section in
                    EventDetailCell(viewData: section,
                                    didTapOnButton: { action in
                                        didTapOnContentButton(action)
                                    })
                }
            }
            .padding(.bottom, 20)
        }
        .padding([.leading, .trailing], Constants.defaultPadding)
        .padding(.top, 24)
        .background(Theme.current.white.color)
        .cornerRadius(Constants.cornerRadius)
    }
}

// MARK: - View Components

private extension EventDetailSection {
    var sectionTitle: some View {
        Text(eventsDetailSectionTitle)
            .foregroundColor(Theme.current.amwayBlack.color)
            .fontWithLineHeight(font: Theme.current.subtitle.uiFont,
                                lineHeight: Theme.current.subtitle.lineHeight,
                                verticalPadding: 0)
            .accessibilityIdentifier(AutomationControl.sectionTitle.accessibilityIdentifier())
    }
}

// MARK: - Constants

private extension EventDetailSection {
    enum Constants {
        static let defaultPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
    }
}

// MARK: - Automation Ids

extension EventDetailSection {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case sectionTitle
    }
}
