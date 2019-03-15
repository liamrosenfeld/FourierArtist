//
//  Notification+Name.swift
//  Fourier Artist
//
//  Created by Liam on 3/14/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let FileChanged = Notification.Name(rawValue: "FileChanged")
    static let InverseFourier = Notification.Name(rawValue: "InverseFourier")
}
