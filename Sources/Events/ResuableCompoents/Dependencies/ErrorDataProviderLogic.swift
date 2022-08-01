//
//  ErrorDataProviderLogic.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import Foundation
import UIKit

public protocol ErrorDataProviderLogic {
    typealias ErrorFieldsCompletion = (Result<ErrorFields, Error>) -> Void
    func fetchConnectivityErrorData(completion: @escaping ErrorFieldsCompletion)
    func fetchInternetErrorData(completion: @escaping ErrorFieldsCompletion)
    func fetchToastErrorData(completion: ErrorFieldsCompletion)
}

public protocol ErrorFields {
    var title: String { get }
    var ctaTitle: String { get }
    var ctaIcon: UIImage? { get }
}
