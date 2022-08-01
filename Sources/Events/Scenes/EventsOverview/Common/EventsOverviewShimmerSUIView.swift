//
//  EventsOverviewShimmerSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct EventsOverviewShimmerSUIView: UIViewRepresentable {
    // MARK: - Instance properties

    @Binding var show: Bool

    func makeUIView(context _: Context) -> EventsOverviewShimmerView {
        EventsOverviewShimmerView()
    }

    func updateUIView(_ uiView: EventsOverviewShimmerView, context _: Context) {
        if show {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}
