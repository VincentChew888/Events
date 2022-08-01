//
//  ConnectivityErrorSUIView.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import SwiftUI

struct ConnectivityErrorSUIView: UIViewControllerRepresentable {
    var customConnectivityErrorData: ConnectivityErrorViewBuilder.ConnectivityErrorData?
    let onTryAgain: () -> Void
    var errorDataProvider: ErrorDataProviderLogic? = PackageDependency.dependencies?.errorDataProvider

    func makeUIViewController(context: Context) -> ConnectivityErrorViewController {
        let viewController = ConnectivityErrorBuilder().build(errorProvider: errorDataProvider)
        viewController.delegate = context.coordinator
        viewController.fetchCSData(customizedData: customConnectivityErrorData)
        return viewController
    }

    func updateUIViewController(_: ConnectivityErrorViewController, context _: Context) {
        // Update here when the state of the containing SwiftUI view changes
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Coordinator

extension ConnectivityErrorSUIView {
    class Coordinator: ConnectivityErrorDelegate {
        let parent: ConnectivityErrorSUIView

        init(_ parent: ConnectivityErrorSUIView) {
            self.parent = parent
        }

        func didTapOnTryAgain() {
            parent.onTryAgain()
        }
    }
}
