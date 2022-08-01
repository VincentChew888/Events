//
//  InternetErrorInteractor.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

protocol InternetErrorBusinessLogic {
    func fetchData(request: InternetError.Model.Request)
}

final class InternetErrorInteractor: InternetErrorBusinessLogic {
    private var presenter: InternetErrorPresentationLogic
    private var errorProvider: ErrorDataProviderLogic?

    init(presenter: InternetErrorPresentationLogic, errorProvider: ErrorDataProviderLogic? = nil) {
        self.presenter = presenter
        self.errorProvider = errorProvider
    }

    // MARK: Fetch Data

    func fetchData(request: InternetError.Model.Request) {
        guard let errorProvider = errorProvider else {
            defaultResponse(request: request)
            return
        }
        errorProvider.fetchInternetErrorData { [weak self] result in
            guard let self = self else {
                self?.defaultResponse(request: request)
                return
            }

            switch result {
            case let .success(fields):
                let title = fields.title.isNotEmpty ? fields.title : InternetErrorText.internetErrorTitle.localized
                let subTitle = fields.ctaTitle.isNotEmpty ? fields.ctaTitle : InternetErrorText.internetErrorSubtitle.localized
                let image = fields.ctaIcon ?? InternetErrorImageAssets.globe.image
                let staticData = InternetError.StaticData(title: title,
                                                          subTitle: subTitle,
                                                          ctaImage: image)
                let response = InternetError.Model.Response(staticData: staticData, customizedData: request.customizedData)
                self.presenter.presentDetails(response: response)
            case .failure:
                self.defaultResponse(request: request)
            }
        }
    }

    func defaultResponse(request: InternetError.Model.Request) {
        let staticData = InternetError.StaticData(title: InternetErrorText.internetErrorTitle.localized,
                                                  subTitle: InternetErrorText.internetErrorSubtitle.localized,
                                                  ctaImage: InternetErrorImageAssets.globe.image)
        let response = InternetError.Model.Response(staticData: staticData, customizedData: request.customizedData)
        presenter.presentDetails(response: response)
    }
}
