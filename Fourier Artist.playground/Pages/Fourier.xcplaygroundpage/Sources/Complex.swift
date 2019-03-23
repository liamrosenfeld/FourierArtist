//
//  Complex.swift
//  Fourier Artist
//
//  Created by Liam on 3/16/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct Complex {
    // Properties
    public var re: Double
    public var im: Double
    
    
    // Operators
    public static func *(left: Complex, right: Complex) -> Complex {
        // (a+bi)(c+di) = ac + adi + bci - bd = (ac - bd) + i(ad + bc)
        var mult = Complex()
        mult.re = left.re * right.re - left.im * right.im;
        mult.im = left.re * right.im + left.im * right.re;
        return mult
    }
    
    public static func +=(left: inout Complex, right: Complex) {
        left.re += right.re
        left.im += right.im
    }
    
    
    // Initilizers
    public init() {
        self.re = 0
        self.im = 0
    }
    
    public init(re: Double, im: Double) {
        self.re = re
        self.im = im
    }
}

extension Point {
    public var complex: Complex {
        get {
            let complex = Complex(re: self.x, im: self.y)
            return complex
        }
    }
}
