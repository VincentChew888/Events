//
//  ConnectivityErrorBuilder.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol ConnectivityErrorSceneBuilder {
    func build(errorProvider: ErrorDataProviderLogic?) -> ConnectivityErrorViewController
}

final class ConnectivityErrorBuilder: ConnectivityErrorSceneBuilder {
    // Add dependencies here

    func build(errorProvider: ErrorDataProviderLogic?) -> ConnectivityErrorViewController {
        let identifier = ConnectivityErrorViewConstants.viewControllerIdentifier
        let viewController: ConnectivityErrorViewController =
            UIStoryboard.makeViewController(name: Storyboard.connectivityError,
                                            identifier: identifier,
                                            bundle: Bundle.resource)
        let presenter: ConnectivityErrorPresenter = ConnectivityErrorPresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.
        let interactor = ConnectivityErrorInteractor(presenter: presenter, errorProvider: errorProvider)

        viewController.setInteractor(interactor: interactor)

        return viewController
    }
}
