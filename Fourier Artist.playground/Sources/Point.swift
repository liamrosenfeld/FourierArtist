//
//  Point.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct Point {
    public var x: Double
    public var y: Double
    
    public var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    // Initilizers
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(from cgpoint: CGPoint) {
        self.x = Double(cgpoint.x)
        self.y = Double(cgpoint.y)
    }
}

extension Point: Codable { }
