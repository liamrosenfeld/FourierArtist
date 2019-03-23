//
//  SKScene+Drawing.swift
//  Fourier Artist
//
//  Created by Liam on 2/13/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import SpriteKit

extension SKScene {
    func drawLine(through points: [CGPoint]) {
        // Get First Point
        var priorPoint = points[0]
        var points = points
        points.remove(at: 0)
        
        // Draw Lines
        for point in points {
            drawLine(from: priorPoint, to: point, color: .green)
            priorPoint = point
        }
    }
    
    func drawLine(from pointOne: CGPoint, to pointTwo: CGPoint, color: NSColor? = nil) {
        // Find Path
        let path = CGMutablePath()
        path.move(to: pointOne)
        path.addLine(to: pointTwo)
        
        // Draw Line
        let line = SKShapeNode(path: path)
        line.lineWidth = 0.01
        line.fillColor = color ?? .white
        line.strokeColor = color ?? .white
        line.name = "Line"
        self.addChild(line)
    }
    
    func drawCircle(center: CGPoint, radius: Double) {
        // Find Square Inscribing Circle
        let corner = CGPoint(x: Double(center.x) - radius, y: Double(center.y) - radius)
        let frame = CGSize(width: radius * 2, height: radius * 2)
        let rect = CGRect(origin: corner, size: frame)
        
        // Draw Circle in Square
        let circle = SKShapeNode.init(ellipseIn: rect)
        circle.strokeColor = .white
        circle.fillColor = .clear
        circle.alpha = 0.5
        circle.name = "Circle"
        self.addChild(circle)
    }
}
