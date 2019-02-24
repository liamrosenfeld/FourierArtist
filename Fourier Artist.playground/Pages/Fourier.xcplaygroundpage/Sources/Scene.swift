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

class Scene: SKScene {
    var fourierX = [ComplexVector]()
    var fourierY = [ComplexVector]()
    
    var theta = 0.0 // Theta on Polar Coordinate
    var delta = 0.0
    var path = [CGPoint]()
    
    // TODO: Don't hardcode default value
    var pointsFile: String = "swiftLogo" {
        didSet {
            path.removeAll()
            theta = 0
            self.removeAllChildren()
            sceneDidLoad()
        }
    }
    
    override func sceneDidLoad() {
        var xValues = [Double]()
        var yValues = [Double]()
        
        for (index, point) in points(from: pointsFile).enumerated() where index % 6 == 0 {
            xValues.append(point.x)
            yValues.append(point.y)
        }
        
        fourierX = dft(x: xValues).sorted{ $0.amp > $1.amp }
        fourierY = dft(x: yValues).sorted{ $0.amp > $1.amp }
        
        delta = Double.pi * 2 / Double(fourierY.count)
    }
    
    override func update(_ currentTime: TimeInterval) {
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

func points(from file: String) -> [Point] {
    var points = [Point]()
    var jsonString = ""
    
    if let url = Bundle.main.url(forResource: file, withExtension: "json") {
        do {
            jsonString = try String(contentsOfFile: url.path)
        } catch {
            fatalError("Empty Json File")
        }
    } else {
        fatalError("No JSON File at \(file)")
    }
    
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    do {
        points = try decoder.decode([Point].self, from: jsonData)
    } catch {
        print(error.localizedDescription)
    }
    
    return points
}
