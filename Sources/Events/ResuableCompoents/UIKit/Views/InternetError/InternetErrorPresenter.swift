//
//  InternetErrorPresenter.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol InternetErrorPresentationLogic {
    func presentDetails(response: InternetError.Model.Response)
}

final class InternetErrorPresenter: InternetErrorPresentationLogic {
    private weak var viewController: InternetErrorDisplayLogic?

    init(viewController: InternetErrorDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: Do something

    func presentDetails(response: InternetError.Model.Response) {
        let viewModel = InternetError.Model.ViewModel(staticData: response.staticData,
                                                      customizedData: response.customizedData)
        DispatchQueue.main.async {
            self.viewController?.displayData(viewModel: viewModel)
        }
    }
}
