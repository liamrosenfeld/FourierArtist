//
//  Fourier.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct ComplexVector {
    var re: Double
    var im: Double
    var freq: Int
    var amp: Double
    var phase: Double
}

func dft(x: [Double]) -> [ComplexVector] {
    var X = [ComplexVector]()
    let N = x.count
    
    for k in 0..<N {
        var re = 0.0 // real component
        var im = 0.0 // imaginary component
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N)
            re += x[n] * cos(phi)
            im -= x[n] * sin(phi)
        }
        
        re = re / Double(N)
        im = im / Double(N)
        
        let amp = sqrt(re * re + im * im)
        let phase = atan2(im, re)
        X.append(ComplexVector(re: re, im: im, freq: k, amp: amp, phase: phase))
    }
    
    return X
}

