//
//  UIViewController+Extension.swift
//  Amway
//
//  Created by Y Media Labs on 06/07/21.
//

import AmwayThemeKit
import SwiftUI
import UIKit

struct AlertModel {
    let title: String?
    let message: String?
    let actionTitles: [String]
    let actionStyles: [UIAlertAction.Style]
    let alertStyle: UIAlertController.Style
}

struct NavBarAppearance {
    var title: String
    var font: UIFont = Theme.current.headline4.uiFont
    var smallTitleFont: UIFont = Theme.current.subtitle2.uiFont
    var bgColor: UIColor = Theme.current.darkPurple.uiColor
    var tintColor: UIColor = Theme.current.amwayWhite.uiColor
}

extension UIViewController {
    /// Add child view controller to controller/view
    /// - Parameters:
    ///   - parent: Parent controller
    ///   - needConstraint: Needs constraint wrt parent
    ///   - needSafeAreaInset: consider safeAreaLayoutGuide  default is false
    /// - Returns: returns ReturnTuple
    @discardableResult func add(to parent: UIViewController,
                                needConstraint: Bool = true,
                                needSafeAreaInset: Bool = false) -> LayoutConstraint?
    {
        var layoutConstraint: LayoutConstraint?
        let parentView: UIView = parent.view
        willMove(toParent: parent)
        parent.addChild(self)
        view.frame = parentView.bounds
        parentView.addSubview(view)
        if needConstraint { layoutConstraint = view.fixBounds(with: parentView, needSafeAreaInset: needSafeAreaInset) }
        didMove(toParent: parent)
        return layoutConstraint
    }

    /// Remove child from parent
    /// - Parameter parent: Parent controller
    func remove(from parent: UIViewController) {
        guard parent.view.subviews.contains(view) else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }

    func statusBarLightTextColor() {
        navigationController?.navigationBar.barStyle = .black
    }

    func applyNavigationBar(appearance: NavBarAppearance,
                            isLargeTitle: Bool = false)
    {
        navigationItem.title = appearance.title
        let navigationBar = navigationController?.navigationBar

        navigationBar?.prefersLargeTitles = isLargeTitle
        navigationBar?.backgroundColor = appearance.bgColor
        navigationBar?.tintColor = appearance.tintColor
        let attributedString = [NSAttributedString.Key.foregroundColor: appearance.tintColor,
                                NSAttributedString.Key.font: appearance.font]
        let smallTitleAttributedString = [NSAttributedString.Key.foregroundColor: appearance.tintColor,
                                          NSAttributedString.Key.font: appearance.smallTitleFont]
        navigationBar?.titleTextAttributes = smallTitleAttributedString
        if isLargeTitle { navigationBar?.largeTitleTextAttributes = attributedString }
        navigationBar?.sizeToFit()
    }

    /// Display alert message using  using UIAlertController
    /// - Parameters:
    ///   - title: title
    ///   - message: alert message
    ///   - options: Button options
    func showAlert(title: String = "",
                   message: String,
                   options: String...,
                   completion: ((Int) -> Void)? = nil)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default, handler: { _ in
                completion?(index)
            })
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }

    /// Method to display alert by specifying the AlertModel object and action handlers for each action
    /// - Parameters:
    ///   - alertModel: The Alert Model
    ///   - actions: Array of action handlers for each action
    ///   - presentCompletion: Completion block
    func showAlert(alertModel: AlertModel,
                   actions: [((UIAlertAction) -> Void)?]? = nil,
                   presentCompletion: (() -> Void)? = nil,
                   preferredActionIndex: Int? = nil)
    {
        let alertController = UIAlertController(title: alertModel.title,
                                                message: alertModel.message,
                                                preferredStyle: alertModel.alertStyle)
        for (index, indexTitle) in alertModel.actionTitles.enumerated() {
            let action = UIAlertAction(title: indexTitle,
                                       style: alertModel.actionStyles[index],
                                       handler: actions?[index])
            alertController.addAction(action)
            if let preferredActionIndex = preferredActionIndex, preferredActionIndex == index {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true) {
            presentCompletion?()
        }
    }

    func addController(child viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }
}

extension UIViewController {
    func addToHostingController<T: View>(hostingController: UIHostingController<T>) {
        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                           hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
                           view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
                           view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)]

        NSLayoutConstraint.activate(constraints)
        hostingController.didMove(toParent: self)
    }
}
