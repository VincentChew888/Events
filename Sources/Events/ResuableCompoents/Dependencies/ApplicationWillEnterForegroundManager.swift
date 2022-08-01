//
//  ApplicationWillEnterForegroundManager.swift
//  Amway
//
//  Copyright (c) 2022 Amway. All rights reserved.

import Foundation
import UIKit

class ApplicationWillEnterForegroundManager {
    private var observer: Any?

    func addObserver(action: @escaping () -> Void) {
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                          object: nil,
                                                          queue: nil,
                                                          using: { _ in
                                                              self.observerAction(action: action)
                                                          })
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(observer as Any)
    }

    private func observerAction(action: @escaping () -> Void) {
        // Added Delay while calling API while app is coming to foreground
        // Reason: requests made immediately upon becoming active gets blocked sometimes with error: network connection was lost
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            action()
        }
    }
}
