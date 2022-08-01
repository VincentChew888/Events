//
//  ConnectivityErrorPresenter.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol ConnectivityErrorPresentationLogic {
    func presentDetails(response: ConnectivityError.Model.Response)
}

final class ConnectivityErrorPresenter: ConnectivityErrorPresentationLogic {
    private weak var viewController: ConnectivityErrorDisplayLogic?

    init(viewController: ConnectivityErrorDisplayLogic) {
        self.viewController = viewController
    }

    func presentDetails(response: ConnectivityError.Model.Response) {
        let viewModel = ConnectivityError.Model.ViewModel(staticData: response.staticData,
                                                          customizedData: response.customizedData)
        DispatchQueue.main.async {
            self.viewController?.displayData(viewModel: viewModel)
        }
    }
}
