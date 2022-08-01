//
//  ToastView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

public struct ToastView: View {
    let viewData: ViewData
    let presenter: ToastViewPresenter?
    let dismissAction: () -> Void

    public init(viewData: ViewData,
                presenter: ToastViewPresenter? = nil,
                dismissAction: @escaping () -> Void)
    {
        self.viewData = viewData
        self.presenter = presenter
        self.dismissAction = dismissAction
    }

    public var body: some View {
        if viewData.messageData.type == .failure, viewData.fetchError, let presenter = presenter {
            presenter.fetchToastErrorData()
        }
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                toastTypeImage
                titleText
                Spacer()
                dismissButton
            }
            .padding(EdgeInsets(top: 0,
                                leading: 12,
                                bottom: 0,
                                trailing: 6))
            descriptionText
        }
        .background(viewData.messageData.type.bgColor)
        .clipShape(RoundedRectangle(cornerRadius: viewData.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: viewData.cornerRadius)
                .stroke(viewData.messageData.type.borderColor, lineWidth: Constant.borderWidth)
        )
    }
}

// MARK: - View components

private extension ToastView {
    var toastTypeImage: some View {
        viewData.messageData.type.image
            .resizable()
            .foregroundColor(viewData.messageData.type.boldColor)
            .frame(width: 16, height: 16)
            .padding(.top, 8)
            .accessibilityIdentifier(AutomationControl.toastStateImageView.accessibilityIdentifier())
    }

    var titleText: some View {
        var title = viewData.messageData.title
        if let presenter = presenter, case let .success(data) = presenter.state {
            title = data.title
        }
        return Text(title)
            .font(Theme.current.bodyTwoBold.font)
            .foregroundColor(viewData.messageData.type.boldColor)
            .padding(.top, 7)
            .accessibilityIdentifier(AutomationControl.titleLabel.accessibilityIdentifier())
    }

    var dismissButton: some View {
        Button {
            dismissAction()
        } label: {
            Image(uiImage: ImageAssets.closeSolid.image)
        }
        .foregroundColor(viewData.messageData.type.boldColor)
        .frame(width: 24, height: 24)
        .padding(.top, 4)
        .accessibilityIdentifier(AutomationControl.closeButton.accessibilityIdentifier())
    }

    var descriptionText: some View {
        var description = viewData.messageData.toastDescription
        if let presenter = presenter, case let .success(data) = presenter.state {
            description = data.description
        }
        return Text(description)
            .font(Theme.current.bodyTwoRegular.font)
            .foregroundColor(viewData.messageData.type.boldColor)
            .padding(EdgeInsets(top: 0,
                                leading: 40,
                                bottom: 7,
                                trailing: 40))
            .accessibilityIdentifier(AutomationControl.toastDescriptionLabel.accessibilityIdentifier())
    }
}
