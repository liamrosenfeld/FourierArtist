//
//  NSView+Background.swift
//  Fourier Artist
//
//  Created by Liam on 3/23/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

extension NSView {
    func setBackground(to color: CGColor) {
        wantsLayer = true
        layer?.backgroundColor = color
    }
}
