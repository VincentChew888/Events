//
//  ImageLoader.swift
//
//
//  Copyright © 2021 Amway. All rights reserved.
//

import UIKit

public protocol ImageLoader: RawRepresentable where RawValue == String {
    var image: UIImage { get }
    var templateImage: UIImage? { get }
    var originalImage: UIImage? { get }
}

public extension ImageLoader {
    var image: UIImage {
        return UIImage(named: rawValue,
                       in: .module,
                       with: .none) ?? UIImage()
    }

    var templateImage: UIImage? {
        return UIImage(named: rawValue,
                       in: .module,
                       with: .none)?
            .withRenderingMode(.alwaysTemplate)
    }

    var originalImage: UIImage? {
        return UIImage(named: rawValue,
                       in: .module,
                       with: .none)?
            .withRenderingMode(.alwaysOriginal)
    }
}
