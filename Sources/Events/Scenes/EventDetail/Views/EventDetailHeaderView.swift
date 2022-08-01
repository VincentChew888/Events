//
//  EventDetailHeaderView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct EventDetailHeaderView: View {
    // MARK: - View Dependencies

    let viewData: ViewData
    let shareData: EventDetail.ShareData
    let actionPerformed: (Action) -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerImage
            titleDescriptionView

            HStack(spacing: 12) {
                FavouriteButton(buttonData: FavouriteButtonData(isSaved: viewData.isFavourite),
                                actionPerformed: actionPerformed)
                shareButton
            }
            .padding(.top, 32)
            .padding([.leading, .trailing], 16)
        }
    }
}

// MARK: - View Components

private extension EventDetailHeaderView {
    var headerImage: some View {
        GeometryReader { geometry in
            AsyncImage(url: viewData.headerImage.encodedURL()) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Theme.current.lightGray.color
            }
            .frame(width: geometry.size.width,
                   height: geometry.frame(in: .global).minY < 0 ? geometry.size.height : geometry.size.height + geometry.frame(in: .global).minY)
            .clipped()
            .offset(y: geometry.frame(in: .global).minY < 0 ? 0 : -geometry.frame(in: .global).minY)
            .accessibilityIdentifier(AutomationControl.headerImage.accessibilityIdentifier())
        }
        .frame(height: 375)
    }

    var titleDescriptionView: some View {
        TitleDescriptionSUIView(viewData: titleDescriptionSUIViewData)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 24)
            .padding([.leading, .trailing], 16)
    }

    var shareButton: some View {
        RoundedImageButton(height: 40, image: EventDetailHeaderViewImageAssets.share.image) {
            actionPerformed(.share(shareData: shareData))
        }
        .accessibilityIdentifier(AutomationControl.shareButton.accessibilityIdentifier())
    }
}

extension EventDetailHeaderView {
    final class FavouriteButtonData: ObservableObject {
        @Published var isSaved: Bool

        init(isSaved: Bool) {
            self.isSaved = isSaved
        }
    }

    struct FavouriteButton: View {
        @ObservedObject var buttonData: FavouriteButtonData
        let actionPerformed: (Action) -> Void

        var body: some View {
            let image: Image = buttonData.isSaved ? EventDetailHeaderViewImageAssets.favourite.image : EventDetailHeaderViewImageAssets.unfavourite.image
            return RoundedImageButton(height: 40, image: image) {
                buttonData.isSaved.toggle()
                actionPerformed(.favourite(isSaved: buttonData.isSaved))
            }
            .accessibilityIdentifier(AutomationControl.favouriteButton.accessibilityIdentifier())
        }
    }
}

// MARK: - Nested types

extension EventDetailHeaderView {
    struct ViewData {
        let headerImage: String
        let title: String
        let description: String
        let viewMoreText: String
        let viewLessText: String
        let isFavourite: Bool
    }

    enum Action {
        case favourite(isSaved: Bool)
        case share(shareData: EventDetail.ShareData)
    }
}

// MARK: - Private

private extension EventDetailHeaderView {
    var titleDescriptionSUIViewData: TitleDescriptionSUIView.ViewData {
        TitleDescriptionSUIView.ViewData(title: viewData.title,
                                         description: viewData.description,
                                         viewMoreText: viewData.viewMoreText,
                                         viewLessText: viewData.viewLessText)
    }
}

// MARK: - Automation Ids

extension EventDetailHeaderView {
    enum AutomationControl: String, AccessibilityIdentifierProvider {
        case headerImage
        case favouriteButton
        case shareButton
    }
}

private extension EventDetailHeaderView {
    enum EventDetailHeaderViewImageAssets: String, ImageLoaderSUI {
        case favourite
        case unfavourite
        case share
    }
}
