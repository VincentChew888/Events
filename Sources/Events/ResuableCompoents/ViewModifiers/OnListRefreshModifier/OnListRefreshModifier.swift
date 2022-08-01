//
//  OnListRefreshModifier.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//

import Introspect
import SwiftUI

struct OnListRefreshModifier: ViewModifier {
    @StateObject private var refreshControlTarget = RefreshControlTarget()
    let refreshControlData: AmwayRefreshControlBuilder.AmwayRefreshControlData
    let onValueChanged: (UIRefreshControl) -> Void

    func body(content: Content) -> some View {
        content
            .introspectTableView { tableView in
                refreshControlTarget.addRefreshControl(on: tableView,
                                                       refreshControlData: refreshControlData,
                                                       onValueChanged: onValueChanged)
            }
    }
}
