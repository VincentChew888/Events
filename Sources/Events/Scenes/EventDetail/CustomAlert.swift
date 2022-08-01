//
//  CustomAlert.swift
//  Amway
//
//  Copyright © 2022 Amway. All rights reserved.
//
import SwiftUI

struct CustomAlertData {
    var title: String = ""
    var message: String = ""
    var primaryButtonText: String = ""
    var secondaryButtonText: String = ""
}

extension View {
    func alert(isPresented: Binding<Bool>,
               data: CustomAlertData,
               primaryButtonAction: (() -> Void)? = nil,
               secondaryButtonAction: (() -> Void)? = nil) -> some View
    {
        var customAlert = Alert(title: Text(data.title),
                                message: Text(data.message),
                                primaryButton: .default(Text(data.primaryButtonText),
                                                        action: primaryButtonAction),
                                secondaryButton: .default(Text(data.secondaryButtonText),
                                                          action: secondaryButtonAction))

        if data.secondaryButtonText.isEmpty {
            customAlert = Alert(title: Text(data.title),
                                message: Text(data.message),
                                dismissButton: .default(Text(data.primaryButtonText),
                                                        action: primaryButtonAction))
        }
        return alert(isPresented: isPresented) {
            customAlert
        }
    }
}
