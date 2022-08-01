//
//  SavedEventsShimmerSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct SavedEventsShimmerSUIView: UIViewRepresentable {
    // MARK: - Instance properties

    @Binding var show: Bool

    func makeUIView(context _: Context) -> SavedEventsShimmerView {
        SavedEventsShimmerView()
    }

    func updateUIView(_ uiView: SavedEventsShimmerView, context _: Context) {
        if show {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
