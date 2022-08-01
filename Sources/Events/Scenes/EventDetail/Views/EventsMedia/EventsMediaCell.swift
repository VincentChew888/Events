//
//  EventsMediaCell.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct EventsMediaCell: View {
    // MARK: - Properties

    let mediaData: MediaData

    // MARK: - DataModel

    struct MediaData: EventMediaDataModel {
        var mediaType: MediaType
        var mediaURL: String
        var mediaTitle: String
        var shareURL: String
        var thumbnailURL: String
        var shareTitle: String
        var contentId: String
        var showPlayerIcons: Bool {
            mediaType == .image ? false : true
        }
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let textPadding: CGFloat = 16
        static let buttonSize: CGFloat = 32
        static let buttonOffset: CGFloat = 8
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: mediaData.thumbnailURL.encodedURL()) { image in
                    image.resizable()
                } placeholder: {
                    Theme.current.lightGray.color
                }
                .accessibilityIdentifier(AutomationControl.mediaImage.accessibilityIdentifier())

                if mediaData.showPlayerIcons {
                    let image = (mediaData.mediaType == MediaType.video) ? EventDetailImageAsset.mediaIcon.image : EventDetailImageAsset.downloadCta.image
                    image
                        .resizable()
                        .frame(width: Constants.buttonSize,
                               height: Constants.buttonSize)
                        .offset(x: -Constants.buttonOffset, y: Constants.buttonOffset)
                        .accessibilityIdentifier((mediaData.mediaType == MediaType.video)
                            ? AutomationControl.mediaIcon.accessibilityIdentifier()
                            : AutomationControl.downloadIcon.accessibilityIdentifier())
                }
            }
            if mediaData.mediaTitle.isNotEmpty {
                Text(mediaData.mediaTitle)
                    .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                        lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                        verticalPadding: 0)
                    .foregroundColor(Theme.current.amwayBlack.color)
                    .padding(.all, Constants.textPadding)
                    .lineLimit(2)
                    .accessibilityIdentifier(AutomationControl.mediaTitle.accessibilityIdentifier())
            }
        }
        .background(Theme.current.white.color)
        .cornerRadius(Constants.cornerRadius)
    }
}

extension EventsMediaCell {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case mediaImage
        case mediaTitle
        case mediaIcon
        case downloadIcon
    }
}
