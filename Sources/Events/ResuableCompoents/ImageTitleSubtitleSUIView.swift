//
//  ImageTitleSubtitleSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct ImageTitleSubtitleSUIView: UIViewRepresentable {
    // MARK: - View Dependencies

    let viewData: ImageTitleSubTitleBuilder.ImageTitleSubtitleViewData
    var buttonAction: (() -> Void)? = nil

    // MARK: - UIViewRepresentable requirements

    func makeUIView(context _: Context) -> ImageTitleSubtitleView {
        let view = ImageTitleSubtitleView()
        view.buttonAction = buttonAction
        view.data = viewData
        return view
    }

    func updateUIView(_ uiView: ImageTitleSubtitleView, context _: Context) {
        uiView.data = viewData
    }
}

// MARK: - Preview

struct ImageTitleSubtitleSUIView_Previews: PreviewProvider {
    static var previews: some View {
        let viewData = ImageTitleSubTitleBuilder()
            .setTitle("No saved events")
            .setSubTitle("Tap the heart icon to save an event. Some events require registration to attend.")
            .setImage(UIImage(named: "globe") ?? UIImage())
            .setButtonData(nil)
            .setImageViewContentMode(.scaleAspectFit)
            .setCornerRadius(12)
            .build()

        ImageTitleSubtitleSUIView(viewData: viewData)
            .frame(height: 248)
    }
}
