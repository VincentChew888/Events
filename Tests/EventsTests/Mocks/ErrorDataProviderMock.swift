//
//  File.swift
//
//
//  Created by Banu Harshavardhan on 29/06/22.
//

import Events
import Foundation

class ErrorDataProviderMock: ErrorDataProviderLogic {
    func fetchConnectivityErrorData(completion: @escaping ErrorFieldsCompletion) {
        completion(.success(ErrorFieldMock(title: "", ctaTitle: "")))
    }

    func fetchInternetErrorData(completion: @escaping ErrorFieldsCompletion) {
        completion(.success(ErrorFieldMock(title: "", ctaTitle: "")))
    }

    func fetchToastErrorData(completion: (Result<ErrorFields, Error>) -> Void) {
        completion(.success(ErrorFieldMock(title: "", ctaTitle: "")))
    }
}
