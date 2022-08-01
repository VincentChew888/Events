//
//  InternetErrorSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct InternetErrorSUIView: UIViewControllerRepresentable {
    var customInternetErrorData: InternetErrorView.InternetErrorViewData?
    var errorDataProvider: ErrorDataProviderLogic? = PackageDependency.dependencies?.errorDataProvider

    func makeUIViewController(context _: Context) -> InternetErrorViewController {
        let internetErrorViewController = InternetErrorBuilder().build(errorProvider: errorDataProvider)
        internetErrorViewController.fetchCSData(customizedData: customInternetErrorData)
        return internetErrorViewController
    }

    func updateUIViewController(_: InternetErrorViewController, context _: Context) {
        // Update here when the state of the containing SwiftUI view changes
    }
}
