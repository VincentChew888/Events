//
//  File.swift
//
//
//  Created by Banu Harshavardhan on 29/06/22.
//

import Combine
@testable import Events
import Foundation

class ToastViewInteractorMock: ToastViewBusinessLogic {
    var fetchSuccess: Bool = false

    func fetchToastError() -> AnyPublisher<ToastError.StaticData, Error> {
        return Future<ToastError.StaticData, Error> { [weak self] promise in
            guard let self = self else {
                self?.fetchSuccess = false
                return promise(.failure(CommonServiceError.invalidDataInFile))
            }
            promise(.success(ToastError.StaticData(title: "title",
                                                   description: "description")))
            self.fetchSuccess = true
        }.eraseToAnyPublisher()
    }
}
