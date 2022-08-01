//
//  CircularShimmerView.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation
import UIKit

final class CircularShimmerView: UIView, NibLoadable {
    @IBOutlet private var shimmerView: ShimmerView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cornerRadius = bounds.height / 2
    }

    // MARK: - Public Methods

    func setGradientColors(colors: [UIColor], locations: [NSNumber]) {
        shimmerView.setGradientColors(colors: colors,
                                      locations: locations)
    }
}

// MARK: - Private Methods

private extension CircularShimmerView {
    func setup() {
        loadFromNib(needSafeAreaInset: false)
    }
}
