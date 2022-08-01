//
//  RoundedImageButton.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

public struct RoundedImageButton: View {
    // MARK: - View Dependencies

    let height: CGFloat
    let image: Image
    let action: () -> Void

    public init(height: CGFloat, image: Image, action: @escaping () -> Void) {
        self.height = height
        self.image = image
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            image
                .resizable()
        }
        .frame(width: height, height: height)
        .clipShape(Circle())
    }
}
