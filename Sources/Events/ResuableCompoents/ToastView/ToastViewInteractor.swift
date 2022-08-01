//
//  File.swift
//
//
//  Created by Amway on 28/06/22.
//

import Combine
import Foundation

protocol ToastViewBusinessLogic {
    func fetchToastError() -> AnyPublisher<ToastError.StaticData, Error>
}

final class ToastViewInteractor: ToastViewBusinessLogic {
    private var provider: ErrorDataProviderLogic!

    init(provider: ErrorDataProviderLogic) {
        self.provider = provider
    }

    func fetchToastError() -> AnyPublisher<ToastError.StaticData, Error> {
        return Future<ToastError.StaticData, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }
            self.provider.fetchToastErrorData { result in
                switch result {
                case let .failure(error):
                    promise(.failure(error))
                case let .success(fields):
                    promise(.success(ToastError.StaticData(title: fields.title,
                                                           description: fields.ctaTitle)))
                }
            }
        }.eraseToAnyPublisher()
    }
}
