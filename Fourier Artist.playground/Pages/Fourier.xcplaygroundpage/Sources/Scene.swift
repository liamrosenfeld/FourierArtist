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
    
    private var xEpicycleStart = CGPoint.zero
    private var yEpicycleStart = CGPoint.zero
    
    
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
    
    // MARK: - Setup
    override public func didMove(to view: SKView) {
        self.backgroundColor = NSColor.black
        
        xEpicycleStart = CGPoint(x: Double(self.frame.width / 2 + 100), y: 100)
        yEpicycleStart = CGPoint(x: 100, y: Double(self.frame.height / 2 + 100))
    }
    
    
    
    // MARK: Cycle
    override public func update(_ currentTime: TimeInterval) {
        // Reset
        self.removeAllChildren()
        
        // Draw Epicycles and Get Next Point For Shape
        let vx = epiCycles(start: xEpicycleStart, rotation: 0, fouriers: fourierX)
        let vy = epiCycles(start: yEpicycleStart, rotation: Double.pi / 2, fouriers: fourierY)
        let v = CGPoint(x: vx.x, y: vy.y)
        
        // Draw Guider Lines
        drawLine(from: vx, to: v)
        drawLine(from: vy, to: v)
        
        // Add New Point To Path and Connect It
        path.insert(v, at: 0)
        drawLine(through: path)
        
        // Update Time (The Theta of the Circle)
        theta += delta
        if (theta > Double.pi * 2) {
            theta = 0
            path.removeAll()
        }
    }
    
    
    
    func epiCycles(start: CGPoint, rotation: Double, fouriers: [ComplexVector]) -> CGPoint {
        // Set Starting Points
        var center = start
        
        for fourier in fouriers {
            let prevCenter = center
            
            // Properties of The Vector
            let freq = fourier.freq
            let radius = fourier.amp
            let phase = fourier.phase
            
            // Draw Ellipse
            drawEllipse(center: prevCenter, radius: radius)
            
            // Find Next Center
            center.x += CGFloat(radius * cos(Double(freq) * theta + phase + rotation))
            center.y += CGFloat(radius * sin(Double(freq) * theta + phase + rotation))
            
            // Draw Line Connecting Centers
            drawLine(from: prevCenter, to: center)
        }
        
        return center
    }
}


