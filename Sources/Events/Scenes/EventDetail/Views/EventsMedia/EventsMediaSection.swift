//
//  EventsMediaSection.swift
//  EventsMedia
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct EventsMediaSection: View {
    // MARK: - Properties

    var title: String
    var items: [EventsMediaCell.MediaData]
    let onItemTap: (EventsMediaCell.MediaData) -> Void

    private enum Constants {
        static let textPadding = EdgeInsets(top: 0, leading: 16.0, bottom: 4.0, trailing: 16.0)
        static let spacing: CGFloat = 8
        static let bottomPadding = 28.0
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWithLineHeight(font: Theme.current.bodyOneBold.uiFont,
                                    lineHeight: Theme.current.bodyOneBold.lineHeight,
                                    verticalPadding: 0)
                .foregroundColor(Theme.current.amwayBlack.color)
                .padding(Constants.textPadding)
                .accessibilityIdentifier(AutomationControl.mediaHeader.accessibilityIdentifier())
            let carouselData = CarouselViewSUIBuilder().build()

            CarouselViewSUI(viewData: carouselData,
                            items: items) { item in
                onItemTap(item)
            } viewBuilder: { item in
                EventsMediaCell(mediaData: item)
            }
        }
        .padding(.bottom, Constants.bottomPadding)
    }
}

extension EventsMediaSection {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case mediaHeader
    }
}
