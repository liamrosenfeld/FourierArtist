//
//  Fourier.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct Wave {
    public var freq: Int
    public var amp: Double
    public var phase: Double
    
    // Initilizers
    public init() {
        self.freq = 0
        self.amp = 0
        self.phase = 0
    }
    
    public init(freq: Int, amp: Double, phase: Double) {
        self.freq = freq
        self.amp = amp
        self.phase = phase
    }
}


