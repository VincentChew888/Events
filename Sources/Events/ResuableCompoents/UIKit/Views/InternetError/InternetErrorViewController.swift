//
//  InternetErrorViewController.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import AmwayThemeKit
import UIKit

protocol InternetErrorDisplayLogic: AnyObject {
    func displayData(viewModel: InternetError.Model.ViewModel)
}

final class InternetErrorViewController: UIViewController {
    @IBOutlet private var internetErrorView: InternetErrorView!

    private var interactor: InternetErrorBusinessLogic?

    private enum Constants {
        static let internetError = "interneterror"
    }

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Injection

    func setInteractor(interactor: InternetErrorBusinessLogic?) {
        self.interactor = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetchCSData(customizedData: InternetErrorView.InternetErrorViewData? = nil) {
        let request = InternetError.Model.Request(uid: Constants.internetError,
                                                  customizedData: customizedData)
        interactor?.fetchData(request: request)
    }
}

// MARK: InternetErrorDisplayLogic

extension InternetErrorViewController: InternetErrorDisplayLogic {
    func displayData(viewModel: InternetError.Model.ViewModel) {
        let customizedData = viewModel.customizedData
        internetErrorView.data = InternetErrorView.InternetErrorViewData(hideGlobeImage: customizedData?.hideGlobeImage ?? false,
                                                                         titleTextColor: customizedData?.titleTextColor ?? Theme.current.amwayBlack.uiColor,
                                                                         subTitleTextColor: customizedData?.subTitleTextColor ?? Theme.current.amwayBlack.uiColor,
                                                                         backgroundColor: customizedData?.backgroundColor ?? .white,
                                                                         title: viewModel.staticData.title,
                                                                         subTitle: viewModel.staticData.subTitle,
                                                                         globeImage: viewModel.staticData.ctaImage)
    }
}
