//
//  EventsDetailShimmerSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct EventsDetailShimmerSUIView: UIViewRepresentable {
    // MARK: - Instance properties

    @Binding var show: Bool

    func makeUIView(context _: Context) -> EventsDetailShimmerView {
        EventsDetailShimmerView()
    }

    func updateUIView(_ uiView: EventsDetailShimmerView, context _: Context) {
        if show {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
