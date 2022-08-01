//
//  EventDetailCell.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//
import AmwayThemeKit
import SwiftUI

struct EventDetailCell: View {
    // MARK: - View Dependencies

    let viewData: ViewData
    let didTapOnButton: (ActionType?) -> Void

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            titleIcon
            VStack(alignment: .leading, spacing: 10.0) {
                titleText
                if viewData.cta.isNotEmpty {
                    contentButton
                }
            }
            Spacer()
        }
    }
}

// MARK: - View Components

private extension EventDetailCell {
    var titleText: some View {
        Text(viewData.title)
            .foregroundColor(Theme.current.amwayBlack.color)
            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                verticalPadding: 0)
            .accessibilityIdentifier(AutomationControl.titleLabel.accessibilityIdentifier())
    }

    var contentButton: some View {
        Button {
            didTapOnButton(viewData.actionType)
        } label: {
            Text(viewData.cta)
                .foregroundColor(Theme.current.darkPurple.color)
                .underline()
                .fontWithLineHeight(font: Theme.current.bodyTwoBold.uiFont,
                                    lineHeight: Theme.current.bodyTwoBold.lineHeight,
                                    verticalPadding: 0)
        }
        .accessibilityIdentifier(AutomationControl.contentButton.accessibilityIdentifier())
    }

    var titleIcon: some View {
        viewData.icon
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .accessibilityIdentifier(AutomationControl.titleIcon.accessibilityIdentifier())
            .offset(x: 0, y: -2)
    }
}

// MARK: - EventDetailCell Data

extension EventDetailCell {
    struct ViewData: Identifiable {
        var id = UUID().uuidString
        var title: String
        var icon: Image
        var cta: String = ""
        var actionType: ActionType?
    }

    enum ActionType {
        case addToCalendar, getDirections
    }
}

// MARK: - Automation Ids

extension EventDetailCell {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case titleIcon
        case titleLabel
        case contentButton
    }
}
