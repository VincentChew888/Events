//
//  InternetErrorBuilder.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol InternetErrorSceneBuilder {
    func build(errorProvider: ErrorDataProviderLogic?) -> InternetErrorViewController
}

final class InternetErrorBuilder: InternetErrorSceneBuilder {
    // Add dependencies here

    func build(errorProvider: ErrorDataProviderLogic?) -> InternetErrorViewController {
        let identifier = InternetErrorConstants.viewControllerIdentifier
        let viewController: InternetErrorViewController = UIStoryboard.makeViewController(name: Storyboard.internetError,
                                                                                          identifier: identifier,
                                                                                          bundle: Bundle.resource)
        let presenter: InternetErrorPresenter = InternetErrorPresenter(viewController: viewController)

        // Inject dependencies into the interactor and create it.'
        let interactor = InternetErrorInteractor(presenter: presenter, errorProvider: errorProvider)

        viewController.setInteractor(interactor: interactor)

        return viewController
    }
}
