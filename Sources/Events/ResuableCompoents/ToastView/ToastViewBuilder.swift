//
//  File.swift
//
//
//  Created by Amway on 28/06/22.
//

import Foundation

public final class ToastViewBuilder {
    public init() {}
    public func build(viewData: ToastView.ViewData, dismissAction: @escaping () -> Void) -> ToastView {
        var presenter: ToastViewPresenter?
        if let provider = PackageDependency.dependencies?.errorDataProvider {
            let interactor = ToastViewInteractor(provider: provider)
            presenter = ToastViewPresenter(interactor: interactor)
        }
        return ToastView(viewData: viewData,
                         presenter: presenter,
                         dismissAction: dismissAction)
    }
}
