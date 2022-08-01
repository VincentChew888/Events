//
//  ConnectivityErrorViewController.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import AmwayThemeKit
import UIKit

protocol ConnectivityErrorDisplayLogic: AnyObject {
    func displayData(viewModel: ConnectivityError.Model.ViewModel)
}

protocol ConnectivityErrorDelegate: AnyObject {
    func didTapOnTryAgain()
}

final class ConnectivityErrorViewController: UIViewController {
    @IBOutlet private var connectivityErrorView: ConnectivityErrorView!

    // MARK: Properties

    private var interactor: ConnectivityErrorBusinessLogic?

    weak var delegate: ConnectivityErrorDelegate?

    private enum Constants {
        static let connectivityError = "connectivityerror"
    }

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Injection

    func setInteractor(interactor: ConnectivityErrorBusinessLogic?) {
        self.interactor = interactor
    }

    func setDelegate(delegate: ConnectivityErrorDelegate?) {
        self.delegate = delegate
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetchCSData(customizedData: ConnectivityErrorViewBuilder.ConnectivityErrorData? = nil) {
        let request = ConnectivityError.Model.Request(uid: Constants.connectivityError,
                                                      customizedData: customizedData)
        interactor?.fetchData(request: request)
    }
}

// MARK: ConnectivityErrorDisplayLogic

extension ConnectivityErrorViewController: ConnectivityErrorDisplayLogic {
    func displayData(viewModel: ConnectivityError.Model.ViewModel) {
        let customizedData = viewModel.customizedData

        let buttonImage = viewModel.staticData.ctaImage ?? UIImage()
        let tintedImage = buttonImage.withRenderingMode(.alwaysTemplate)

        var buttonData = AmwayButtonBuilder()
            .setTitle(viewModel.staticData.ctaTitle)
            .setTextFont(Theme.current.buttonBodyTwo.uiFont)
            .setBorderWidth(0)
            .setImageAlignment(.left)
            .setContentSpacing(10)
            .setImage(tintedImage)

        if let customizedData = customizedData {
            buttonData = buttonData.setColors(customizedData.colors)
        }

        let connectivityErrorViewData = ConnectivityErrorView.ConnectivityErrorViewData(titleTextColor: customizedData?.textColor ?? Theme.current.amwayBlack.uiColor,
                                                                                        backgroundColor: customizedData?.backgroundColor ?? .white,
                                                                                        buttonData: buttonData.build(),
                                                                                        title: viewModel.staticData.title)

        connectivityErrorView.data = connectivityErrorViewData
        connectivityErrorView.delegate = self
    }
}

// MARK: ConnectivityErrorViewDelegate

extension ConnectivityErrorViewController: ConnectivityErrorViewDelegate {
    func didTapOnTryAgain() {
        delegate?.didTapOnTryAgain()
    }
}
