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
        var priorPoint = points[0]
        var points = points
        points.remove(at: 0)
        for point in points {
            drawLine(from: priorPoint, to: point)
            priorPoint = point
        }
    }
    
    func drawLine(from pointOne: CGPoint, to pointTwo: CGPoint) {
        var line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: pointOne)
        path.addLine(to: pointTwo)
        line = SKShapeNode(path: path)
        line.lineWidth = 0.01
        line.fillColor = NSColor.white
        line.name = "Line"
        self.addChild(line)
    }
    
    func drawEllipse(center: CGPoint, radius: Double) {
        let corner = CGPoint(x: Double(center.x) - (radius/2), y: Double(center.y) - (radius/2))
        let frame = CGSize(width: radius * 2, height: radius * 2)
        let rect = CGRect(origin: corner, size: frame)
        let ellipse = SKShapeNode.init(ellipseIn: rect)
        ellipse.strokeColor = NSColor.white
        ellipse.fillColor = NSColor.clear
        ellipse.alpha = 0.5
        ellipse.name = "Ellipse"
        self.addChild(ellipse)
    }
}
