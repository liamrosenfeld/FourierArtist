//
//  NSBezierPath+CGPath.swift
//  Fourier Artist
//
//  Created by Liam on 2/15/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

import AppKit

public extension NSBezierPath {
    
    public var points: [CGPoint] {
        // Convert to CGPath
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo: path.move(to: points[0])
            case .lineTo: path.addLine(to: points[0])
            case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath: path.closeSubpath()
            }
        }
        
        // Get Points
        points = [CGPoint]()
        path.applyWithBlock { pointer in
            let element = pointer.pointee
            points.append(element.points.pointee)
        }
        
        return points
    }
    
}
