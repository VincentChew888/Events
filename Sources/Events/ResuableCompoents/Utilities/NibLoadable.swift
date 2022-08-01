//
//  NibLoadable.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import UIKit

protocol NibLoadable: AnyObject {
    func loadFromNib(needSafeAreaInset: Bool)
}

extension NibLoadable where Self: UIView {
    func loadFromNib(needSafeAreaInset: Bool = true) {
        guard let view = viewFromNibForClass() else { return }

        addSubview(view)
        view.fixBounds(with: self, needSafeAreaInset: needSafeAreaInset)
    }

    func viewFromNibForClass() -> UIView? {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.resource)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
