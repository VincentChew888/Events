//
//  EventDetailsConnectivityErrorView.swift
//
//
//  Copyright © 2022 Amway. All rights reserved.
//

import AmwayThemeKit
import SwiftUI

struct EventDetailsConnectivityErrorView: View {
    @ObservedObject private var presenter: EventDetailPresenter
    var connectivityErrorButtonData: AmwayButtonBuilder.AmwayButtonColors
    var connectivityError: ConnectivityErrorViewBuilder.ConnectivityErrorData

    init(presenter: EventDetailPresenter) {
        self.presenter = presenter
        connectivityErrorButtonData = AmwayButtonBuilder.AmwayButtonColors(textColor: .white,
                                                                           backgroundColor: Theme.current.darkPurple.uiColor,
                                                                           tintColor: .white,
                                                                           borderColor: Theme.current.darkPurple.uiColor)
        connectivityError = ConnectivityErrorViewBuilder.ConnectivityErrorData(colors: connectivityErrorButtonData,
                                                                               textColor: .white,
                                                                               backgroundColor: Theme.current.darkPurple.uiColor)
    }

    var body: some View {
        ZStack {
            Theme.current.darkPurple.color.edgesIgnoringSafeArea(.all)
            VStack {
                ConnectivityErrorSUIView(customConnectivityErrorData: connectivityError, onTryAgain: {
                    presenter.fetchEventDetail(type: .initialLoad)
                })
                .frame(height: 104)
                .padding([.leading, .trailing], 16)
            }
        }
    }
}
