//
//  InternetErrorModels.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import UIKit

enum InternetError {
    // MARK: Use cases

    enum Model {
        struct Request {
            var uid: String
            var customizedData: InternetErrorView.InternetErrorViewData?
        }

        struct Response {
            var staticData: StaticData
            var customizedData: InternetErrorView.InternetErrorViewData?
        }

        struct ViewModel {
            var staticData: StaticData
            var customizedData: InternetErrorView.InternetErrorViewData?
        }
    }

    struct StaticData {
        var title: String
        var subTitle: String
        var ctaImage: UIImage?
    }
}
