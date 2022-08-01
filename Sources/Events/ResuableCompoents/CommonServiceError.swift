//
//  CommonServiceError.swift
//  Amway
//
//  Copyright © 2021 Amway. All rights reserved.
//

import Foundation

enum CommonServiceError: Error {
    case invalidDataInFile
    case emptyData
    case internetFailure
    case refreshTokenAPIFailed
    case duplicateApiCall
}

extension CommonServiceError: LocalizedError {
    var errorDescription: String? {
        let value: String
        switch self {
        case .invalidDataInFile:
            value = "INVALID_DATA_IN_FILE"
        case .emptyData:
            value = "EMPTY_DATA"
        case .internetFailure:
            value = "INTERNET_FAILURE"
        case .refreshTokenAPIFailed:
            value = "REFRESH_TOKEN_API_FAILURE"
        case .duplicateApiCall:
            value = "DUPLICATE_API_CALL"
        }
        return value
    }
}
