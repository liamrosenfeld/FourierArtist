//
//  Fourier.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct ComplexVector {
    public var re: Double
    public var im: Double
    public var freq: Int
    public var amp: Double
    public var phase: Double
    
    public init(re: Double, im: Double, freq: Int, amp: Double, phase: Double) {
        self.re = re
        self.im = im
        self.freq = freq
        self.amp = amp
        self.phase = phase
    }
}

public struct ComplexVectorSet {
    public var x: [ComplexVector]
    public var y: [ComplexVector]
    
    public init(_ x: [ComplexVector], _ y: [ComplexVector]) {
        self.x = x
        self.y = y
    }
}


