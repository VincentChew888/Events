//
//  UILabel+Extension.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import UIKit

extension UILabel {
    struct LabelInfo {
        var isTruncated: Bool
        var visibleNoOfLines: Int
    }

    func labelInfo(needLayoutChange: Bool = true) -> LabelInfo {
        guard let labelText = text,
              let font = font
        else { return LabelInfo(isTruncated: false,
                                visibleNoOfLines: numberOfLines) }

        if needLayoutChange { layoutIfNeeded() }
        let labelTextSize = (labelText as NSString).boundingRect(with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
                                                                 options: .usesLineFragmentOrigin,
                                                                 attributes: [.font: font],
                                                                 context: nil).size

        let height = labelTextSize.height
        return LabelInfo(isTruncated: height > bounds.size.height,
                         visibleNoOfLines: Int(ceil(height / font.lineHeight)))
    }

    func heightForView(text: NSMutableAttributedString, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = text
        label.sizeToFit()
        return label.frame.height
    }
}
