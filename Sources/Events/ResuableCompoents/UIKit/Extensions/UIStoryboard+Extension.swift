//
//  UIStoryboard+Extension.swift
//  Amway
//
//  Copyright © Amway. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func makeViewController<ViewController>(name: String, identifier: String, bundle: Bundle? = nil) -> ViewController
        where ViewController: UIViewController
    {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(identifier: identifier)
    }
}
