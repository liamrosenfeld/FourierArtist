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
    // MARK: - Constants
    private var theta = 0.0 // Theta on Polar Coordinate. Acts as Time.
    private var delta = 0.0
    private var path = [CGPoint]()
    
    // MARK: - Epicycles
    public var epicycles = [Wave]() {
        didSet {
            path.removeAll()
            theta = 0
            self.removeAllChildren()
            delta = Double.pi * 2 / Double(epicycles.count)
        }
    }
    
    // MARK: - Setup
    override public func didMove(to view: SKView) {
        self.backgroundColor = NSColor.black
    }
    
    // MARK: - Cycle
    override public func update(_ currentTime: TimeInterval) {
        // Reset
        self.removeAllChildren()
        
        // Draw Epicycles and Get Next Point For Shape
        let v = epicycles(epicycles: epicycles)
        
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
    
    func epicycles(epicycles: [Wave]) -> CGPoint {
        // Get Starting Point
        var center = CGPoint(x: Double(self.frame.width / 2),
                             y: Double(self.frame.height / 2))
        
        // Draw Epicycles
        for epi in epicycles {
            let prevCenter = center
            
            // Properties of The Vector
            let freq = epi.freq
            let radius = epi.amp
            let phase = epi.phase
            
            // Find Next Center
            let phi = Double(freq) * theta + phase
            center.x += CGFloat(radius * cos(phi))
            center.y += CGFloat(radius * sin(phi))
            
            // Draw Ellipse and Line Connecting Centers
            drawEllipse(center: prevCenter, radius: radius)
            drawLine(from: prevCenter, to: center)
        }
        
        return center
    }
}


