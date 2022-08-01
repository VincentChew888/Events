//
//  ConnectivityErrorInteractor.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol ConnectivityErrorBusinessLogic {
    func fetchData(request: ConnectivityError.Model.Request)
}

final class ConnectivityErrorInteractor: ConnectivityErrorBusinessLogic {
    private var presenter: ConnectivityErrorPresentationLogic
    private var errorProvider: ErrorDataProviderLogic?

    init(presenter: ConnectivityErrorPresentationLogic, errorProvider: ErrorDataProviderLogic? = nil) {
        self.presenter = presenter
        self.errorProvider = errorProvider
    }

    // MARK: Fetch Data

    func fetchData(request: ConnectivityError.Model.Request) {
        guard let errorProvider = errorProvider else {
            defaultResponse(request: request)
            return
        }
        errorProvider.fetchConnectivityErrorData { [weak self] result in
            guard let self = self else {
                self?.defaultResponse(request: request)
                return
            }

            switch result {
            case let .success(fields):
                let title = fields.title.isNotEmpty ? fields.title : ConnectivityErrorConstants.apiErrorTitle.localized
                let subTitle = fields.ctaTitle.isNotEmpty ? fields.ctaTitle : ConnectivityErrorConstants.apiErrorSubtitle.localized
                let image = fields.ctaIcon ?? ConnectivityErrorImageAssets.tryAgain.image
                let staticData = ConnectivityError.StaticData(title: title,
                                                              ctaTitle: subTitle,
                                                              ctaImage: image)
                let response = ConnectivityError.Model.Response(staticData: staticData,
                                                                customizedData: request.customizedData)
                self.presenter.presentDetails(response: response)
            case .failure:
                self.defaultResponse(request: request)
            }
        }
    }

    func defaultResponse(request: ConnectivityError.Model.Request) {
        let staticData = ConnectivityError.StaticData(title: ConnectivityErrorConstants.apiErrorTitle.localized,
                                                      ctaTitle: ConnectivityErrorConstants.apiErrorSubtitle.localized,
                                                      ctaImage: ConnectivityErrorImageAssets.tryAgain.image)
        let response = ConnectivityError.Model.Response(staticData: staticData, customizedData: request.customizedData)
        presenter.presentDetails(response: response)
    }
}
