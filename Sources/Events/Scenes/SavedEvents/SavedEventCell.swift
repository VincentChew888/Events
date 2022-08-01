//
//  SavedEventCell.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct SavedEventCell: View {
    // TODO: Replace with actual model values
    @State var event: SavedEventsData
    let didTapSaveButton: (SavedEventsData) -> Void
    let analyticsEventCompletion: SavedEventsView.AnalyticsEventCompletion
    let didTapEvent: (String) -> Void

    private enum Constants {
        static let defaultPadding: CGFloat = 16
        static let cellHeight: CGFloat = 299
        static let eventImageHeight: CGFloat = 193
        static let yOffset: CGFloat = 8
        static let bottomInsets: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let imageHeight: CGFloat = 32
        static let titleHeight: CGFloat = 48
    }

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // EventImage
                AsyncImage(url: event.imageUrl.encodedURL()) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Theme.current.lightGray.color
                }
                .frame(maxWidth: .infinity,
                       minHeight: Constants.eventImageHeight,
                       maxHeight: Constants.eventImageHeight,
                       alignment: .center)
                .clipped()
                .accessibilityIdentifier(AutomationControl.savedEventImage.accessibilityIdentifier())
                // SavedIcon
                Button {
                    event.isSaved = !event.isSaved
                    didTapSaveButton(event)
                    analyticsEventCompletion(.saveEvent, event)
                } label: {
                    Image(uiImage: event.isSaved ? EventsOverviewImageAssets.saveIconBlack.image : EventsOverviewImageAssets.saveIconWhite.image)
                }
                .buttonStyle(.plain)
                .frame(width: Constants.imageHeight, height: Constants.imageHeight)
                .offset(x: -Constants.yOffset, y: Constants.yOffset)
                .accessibilityIdentifier(event.isSaved
                    ? AutomationControl.savedIcon.accessibilityIdentifier()
                    : AutomationControl.saveIcon.accessibilityIdentifier())
            }
            Spacer(minLength: Constants.defaultPadding)
            // Title Text
            Text(event.title)
                .frame(width: nil, height: Constants.titleHeight, alignment: .top)
                .foregroundColor(Theme.current.amwayBlack.color)
                .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont,
                                    lineHeight: Theme.current.bodyOneMedium.lineHeight,
                                    verticalPadding: 0)
                .padding([.leading, .trailing], Constants.defaultPadding)
                .accessibilityIdentifier(AutomationControl.savedEventTitle.accessibilityIdentifier())
                .lineLimit(2)

            Spacer(minLength: Constants.bottomInsets)
            // Descrption Text
            Text(event.description)
                .foregroundColor(Theme.current.gray5.color)
                .fontWithLineHeight(font: Theme.current.bodyTwoRegular.uiFont,
                                    lineHeight: Theme.current.bodyTwoRegular.lineHeight,
                                    verticalPadding: 0)
                .padding([.leading, .trailing], Constants.defaultPadding)
                .accessibilityIdentifier(AutomationControl.savedEventDescription.accessibilityIdentifier())
                .lineLimit(1)
            Spacer(minLength: Constants.defaultPadding)
        }
        .background(Theme.current.white.color)
        .listRowBackground(Theme.current.backgroundGray.color)
        .listRowInsets(EdgeInsets(top: Constants.yOffset,
                                  leading: Constants.defaultPadding,
                                  bottom: Constants.bottomInsets,
                                  trailing: Constants.defaultPadding))
        .cornerRadius(Constants.cornerRadius)
        .onTapGesture {
            analyticsEventCompletion(.viewEventDetails, event)
            didTapEvent(event.eventId)
        }
    }
}

private extension SavedEventCell {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case savedEventImage
        case savedEventTitle
        case savedEventDescription
        case savedIcon
        case saveIcon
    }
}
