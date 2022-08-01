//
//  UIView+Extension.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import AmwayThemeKit
import UIKit

@IBDesignable
public extension UIView {
    @IBInspectable var borderColor: UIColor {
        get {
            UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            guard let shadowColor = layer.shadowColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var shadowWidthOffset: CGFloat {
        get {
            layer.shadowOffset.width
        }
        set {
            layer.shadowOffset.width = newValue
        }
    }

    @IBInspectable var shadowHeightOffset: CGFloat {
        get {
            layer.shadowOffset.height
        }
        set {
            layer.shadowOffset.height = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            clipsToBounds = false
        }
    }
}

// MARK: - NSLayout extension.

extension UIView {
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// - Parameters:
    ///   - superView: parent view
    ///   - insets: UIEdgeInsets if required, default is .zero
    ///   - heightConstant: height
    ///   - needSafeAreaInset: consider safeAreaLayoutGuide
    /// - Returns: returns ReturnTouple with leading, trailing, top etc ..
    @discardableResult func fixBounds(with superView: UIView,
                                      insets: UIEdgeInsets = .zero,
                                      heightConstant: CGFloat? = nil,
                                      needSafeAreaInset: Bool = true) -> LayoutConstraint
    {
        let leading, trailing, top: NSLayoutConstraint
        var bottom: NSLayoutConstraint?
        var height: NSLayoutConstraint?
        if needSafeAreaInset {
            leading = safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                                                                   constant: insets.left)
            let trailingAnchor = safeAreaLayoutGuide.trailingAnchor
            trailing = superView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                                               constant: insets.right)
            top = safeAreaLayoutGuide.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor,
                                                           constant: insets.top)
            if let heightConstant = heightConstant {
                height = safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: heightConstant)
            } else {
                let bottomAnchor = safeAreaLayoutGuide.bottomAnchor
                bottom = superView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                               constant: insets.bottom)
            }
        } else {
            leading = leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left)
            trailing = superView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets.right)
            top = topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top)
            if let heightConstant = heightConstant {
                height = heightAnchor.constraint(equalToConstant: heightConstant)
            } else {
                bottom = superView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom)
            }
        }
        let layoutConstraint = LayoutConstraint(leadingConstraint: leading,
                                                trailingConstraint: trailing,
                                                topConstraint: top,
                                                bottomConstraint: bottom,
                                                heightConstraint: height)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leading, trailing, top])
        guard let constraint = height ?? bottom else { return layoutConstraint }
        NSLayoutConstraint.activate([constraint])
        return layoutConstraint
    }

    /// Dynamic size for tableview header/footer
    /// - Returns: modified height
    @discardableResult func viewSizeToFit() -> UIView {
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        guard frame.size.height != size.height else { return self }

        frame.size.height = size.height
        return self
    }

    /// Generic function for loading nib
    /// - Returns: loaded class
    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T
    }

    /// To add rounded corners to view
    /// - Parameters:
    ///     - corners: Array of Corners, ex: [.bottomLeft, .bottomRight, .topRight, .topLeft]
    ///     - radius: Radius for rounded corner
    func roundCorners(for corners: UIRectCorner = .allCorners, radius: CGFloat = 10) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()

        mask.path = path.cgPath
        layer.mask = mask
    }

    /// Returns the ultimate parent view
    var parentView: UIView? {
        var parentView: UIView?
        var view: UIView? = self

        while view != nil {
            if let superView = view?.superview {
                parentView = superview
                view = superView
            } else {
                view = nil
            }
        }

        return parentView
    }
}

extension UIView {
    func applyArcOnTop() {
        let bezierPath = createBezierPath()
        let shapeLayer = createShapeLayer(using: bezierPath)
        shapeLayer.name = CommonLayerConstants.bezierPath
        layer.sublayers?.filter { $0.name == CommonLayerConstants.bezierPath }.forEach { $0.removeFromSuperlayer() }
        layer.insertSublayer(shapeLayer, at: 0)
    }

    private func createBezierPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: 0,
                                       y: bounds.height))
        bezierPath.addLine(to: CGPoint(x: bounds.width,
                                       y: bounds.height))
        bezierPath.addLine(to: CGPoint(x: bounds.width,
                                       y: 0))
        bezierPath.addCurve(to: CGPoint.zero,
                            controlPoint1: CGPoint(x: bounds.width * 0.666, y: 16),
                            controlPoint2: CGPoint(x: bounds.width * 0.333, y: 16))
        bezierPath.close()
        return bezierPath
    }

    private func createShapeLayer(using bezier: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = Theme.current.create.uiColor.cgColor
        return shapeLayer
    }

    func applyCornerRadiusForCorners(_ corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner],
                                     radius: CGFloat)
    {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}
