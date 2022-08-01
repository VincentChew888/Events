//
//  RoutingLogic.swift
//  Amway
//
//  Copyright © Amway. All rights reserved.
//

import Foundation

protocol RoutingLogic {
    associatedtype Destination
    func navigate(to destination: Destination)
}
