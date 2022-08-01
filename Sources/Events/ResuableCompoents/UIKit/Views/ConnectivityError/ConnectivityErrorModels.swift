//
//  ConnectivityErrorModels.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

enum ConnectivityError {
    // MARK: Use cases

    enum Model {
        struct Request {
            var uid: String
            var customizedData: ConnectivityErrorViewBuilder.ConnectivityErrorData?
        }

        struct Response {
            var staticData: StaticData
            var customizedData: ConnectivityErrorViewBuilder.ConnectivityErrorData?
        }

        struct ViewModel {
            var staticData: StaticData
            var customizedData: ConnectivityErrorViewBuilder.ConnectivityErrorData?
        }
    }

    struct StaticData {
        var title: String
        var ctaTitle: String
        var ctaImage: UIImage?
    }
}
