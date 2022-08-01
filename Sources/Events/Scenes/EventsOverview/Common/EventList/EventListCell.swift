//
//  EventListCell.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct EventListCell: View {
    // TODO: Replace with actual model values
    @State var event: EventsData
    let didTapEvent: (String) -> Void
    let didTapSaveButton: (EventsData) -> Void
    let analyticsEventCompletion: EventsOverviewView.AnalyticsEventCompletion

    private enum Constants {
        static let defaultPadding: CGFloat = 16
        static let cellHeight: CGFloat = 106
        static let topInsets: CGFloat = 4
        static let bottomInsets: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let imageOffset: CGFloat = 8
        static let imageHeight: CGFloat = 32
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.title)
                    .foregroundColor(Theme.current.amwayBlack.color)
                    .fontWithLineHeight(font: Theme.current.bodyOneMedium.uiFont, lineHeight: Theme.current.bodyOneMedium.lineHeight, verticalPadding: 0)
                    .padding(.leading, Constants.defaultPadding)
                    .padding(.top, Constants.defaultPadding)
                    .accessibilityIdentifier(AutomationControl.eventTitle.accessibilityIdentifier())
                    .lineLimit(2)
                Spacer()
                Text(event.description)
                    .foregroundColor(Theme.current.gray5.color)
                    .fontWithLineHeight(font: Theme.current.bodyTwoRegular.uiFont, lineHeight: Theme.current.bodyTwoRegular.lineHeight, verticalPadding: 0)
                    .padding(.leading, Constants.defaultPadding)
                    .padding(.bottom, Constants.defaultPadding)
                    .accessibilityIdentifier(AutomationControl.eventDescription.accessibilityIdentifier())
                    .lineLimit(1)
            }
            Spacer()
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: event.imageUrl.encodedURL()) { image in
                    image
                        .resizable()
                } placeholder: {
                    Theme.current.lightGray.color
                }
                .scaledToFit()
                .frame(width: Constants.cellHeight, height: Constants.cellHeight)
                .accessibilityIdentifier(AutomationControl.eventImage.accessibilityIdentifier())
                Button {
                    event.isSaved = !event.isSaved
                    didTapSaveButton(event)
                    analyticsEventCompletion(.saveEvent, event)
                } label: {
                    Image(uiImage: event.isSaved ? EventsOverviewImageAssets.saveIconBlack.image : EventsOverviewImageAssets.saveIconWhite.image)
                }
                .frame(width: Constants.imageHeight, height: Constants.imageHeight)
                .offset(x: -Constants.imageOffset, y: Constants.imageOffset)
                .accessibilityIdentifier(event.isSaved
                    ? AutomationControl.savedIcon.accessibilityIdentifier()
                    : AutomationControl.saveIcon.accessibilityIdentifier())
            }
        }
        .background(Theme.current.white.color)
        .buttonStyle(PlainButtonStyle())
        .listRowInsets(EdgeInsets(top: 0,
                                  leading: Constants.defaultPadding,
                                  bottom: Constants.bottomInsets,
                                  trailing: Constants.defaultPadding))
        .listRowBackground(Theme.current.backgroundGray.color)
        .cornerRadius(Constants.cornerRadius)
        .onTapGesture {
            analyticsEventCompletion(.viewEventDetails, event)
            didTapEvent(event.eventId)
        }
    }
}

// MARK: - Accessibility

private extension EventListCell {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case eventImage
        case eventTitle
        case eventDescription
        case savedIcon
        case saveIcon
    }
}
