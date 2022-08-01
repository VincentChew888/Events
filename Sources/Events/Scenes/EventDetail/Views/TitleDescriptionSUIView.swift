//
//  TitleDescriptionSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct TitleDescriptionSUIView: View {
    // MARK: - View Dependencies

    let viewData: ViewData

    // MARK: - Private Properties

    @State private var descriptionTruncates = false
    @State private var isDescriptionExpanded = true

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleText
            descriptionText

            if descriptionTruncates {
                viewMoreButton
            }
        }
    }
}

// MARK: - View Components

private extension TitleDescriptionSUIView {
    var titleText: some View {
        Text(viewData.title)
            .foregroundColor(Theme.current.amwayBlack.color)
            .fontWithLineHeight(font: Theme.current.headline4.uiFont,
                                lineHeight: Theme.current.headline4.lineHeight,
                                verticalPadding: 0)
            .accessibilityIdentifier(AutomationControl.titleLabel.accessibilityIdentifier())
    }

    var descriptionText: some View {
        Text(viewData.description)
            .foregroundColor(Theme.current.amwayBlack.color)
            .fontWithLineHeight(font: Theme.current.bodyOneRegular.uiFont,
                                lineHeight: Theme.current.bodyOneRegular.lineHeight,
                                verticalPadding: 0)
            .lineLimit(isDescriptionExpanded ? nil : Constant.maxNumberOfLinesWhenCollapsed)
            .background(// Determine whether the text will span more number of line than `maxNumberOfLinesWhenCollapsed`.
                // Render the text in collapsed state to determine the text size
                Text(viewData.description)
                    .fontWithLineHeight(font: Theme.current.bodyOneRegular.uiFont,
                                        lineHeight: Theme.current.bodyOneRegular.lineHeight,
                                        verticalPadding: 0)
                    .lineLimit(Constant.maxNumberOfLinesWhenCollapsed)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            determineTruncation(geometry)
                        }
                    })
                    .hidden())
            .accessibilityIdentifier(AutomationControl.descriptionLabel.accessibilityIdentifier())
    }

    var viewMoreButton: some View {
        Button {
            isDescriptionExpanded.toggle()
        } label: {
            Text(isDescriptionExpanded ? viewData.viewLessText : viewData.viewMoreText)
                .foregroundColor(Theme.current.amwayBlack.color)
                .underline()
                .fontWithLineHeight(font: Theme.current.bodyTwoBold.uiFont,
                                    lineHeight: Theme.current.bodyTwoBold.lineHeight,
                                    verticalPadding: 0)
        }
        .accessibilityIdentifier(AutomationControl.viewMoreButton.accessibilityIdentifier())
    }
}

// MARK: - Nested Types

extension TitleDescriptionSUIView {
    struct ViewData {
        let title: String
        let description: String
        let viewMoreText: String
        let viewLessText: String
    }

    enum Constant {
        static let maxNumberOfLinesWhenCollapsed = 4
    }
}

// MARK: - Private

private extension TitleDescriptionSUIView {
    func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the text given the width from the GeometryReader.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = Theme.current.bodyOneRegular.lineHeight
        paragraphStyle.minimumLineHeight = Theme.current.bodyOneRegular.lineHeight

        let size = CGSize(width: geometry.size.width,
                          height: .greatestFiniteMagnitude)

        let attributes: [NSAttributedString.Key: Any] = [.font: Theme.current.bodyOneRegular.uiFont,
                                                         .paragraphStyle: paragraphStyle]

        let boundingRect = viewData.description.boundingRect(with: size,
                                                             options: .usesLineFragmentOrigin,
                                                             attributes: attributes,
                                                             context: nil)

        if boundingRect.size.height > geometry.size.height {
            descriptionTruncates = true
        }
    }
}

// MARK: - Automation Ids

extension TitleDescriptionSUIView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case titleLabel
        case descriptionLabel
        case viewMoreButton
    }
}
