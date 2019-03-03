//
//  Scene.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

public class Scene: SKScene {
    // MARK: Constants
    private var theta = 0.0 // Theta on Polar Coordinate
    private var delta = 0.0
    private var path = [CGPoint]()
    
    
    // MARK: Points
    private var fourierX = [ComplexVector]()
    private var fourierY = [ComplexVector]()
    
    public func setPoints(to points: ComplexVectorSet) {
        fourierX = points.x
        fourierY = points.y
        
        path.removeAll()
        theta = 0
        self.removeAllChildren()
        delta = Double.pi * 2 / Double(fourierY.count)
    }
    
    
    // MARK: Cycle
    override public func update(_ currentTime: TimeInterval) {
        self.removeAllChildren()
        self.backgroundColor = NSColor.black

        let vx = epiCycles(x: Double(self.frame.width / 2 + 100), y: 100, rotation: 0, fouriers: fourierX)
        let vy = epiCycles(x: 100, y: Double(self.frame.height / 2 + 100), rotation: Double.pi / 2, fouriers: fourierY)
        let v = CGPoint(x: vx.x, y: vy.y)
        path.insert(v, at: 0)
        drawLine(from: vx, to: v)
        drawLine(from: vy, to: v)

        drawLine(through: path)
        theta += delta
        if (theta > Double.pi * 2) {
            theta = 0
            path.removeAll()
        }
    }
    
    func epiCycles(x: Double, y: Double, rotation: Double, fouriers: [ComplexVector]) -> CGPoint {
        var x = x
        var y = y
        
        for fourier in fouriers {
            let prevPoint = CGPoint(x: x, y: y)
            
            let freq = fourier.freq
            let radius = fourier.amp
            let phase = fourier.phase
            x += radius * cos(Double(freq) * theta + phase + rotation)
            y += radius * sin(Double(freq) * theta + phase + rotation)
            
            drawEllipse(center: prevPoint, radius: radius)
            
            let newPoint = CGPoint(x: x, y: y)
            drawLine(from: prevPoint, to: newPoint)
        }
        
        return CGPoint(x: x, y: y)
    }
}


