//
//  DrawView.swift
//  Fourier Artist
//
//  Created by Liam on 2/15/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class DrawView: NSView {
    var drawColor = NSColor.black
    var lineWidth: CGFloat = 2
    
    var path = NSBezierPath()
    var fullPath = NSBezierPath()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initBezierPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBezierPath()
    }
    
    func initBezierPath() {
        path.lineCapStyle = NSBezierPath.LineCapStyle.round
        path.lineJoinStyle = NSBezierPath.LineJoinStyle.round
    }
    
    // Setup
    override func viewWillDraw() {
        setBackground(to: .white)
    }
    
    // MARK: - Touch handling
    let pointLimit: Int = 128
    var pointCounter: Int = 0
    
    var lastPoint = CGPoint.zero
    
    override func mouseDown(with event: NSEvent) {
        clear()
        lastPoint = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        let newPoint = event.locationInWindow
        
        path.move(to: lastPoint)
        path.line(to: newPoint)
        lastPoint = newPoint
        
        pointCounter += 1
        
        if pointCounter == pointLimit {
            pointCounter = 0
            renderToImage()
            display()
            fullPath.append(path)
            path.removeAllPoints()
        } else {
            display()
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        pointCounter = 0
        renderToImage()
        display()
        fullPath.append(path)
        path.removeAllPoints()
    }
    
    // MARK: - Render
    private var render: NSImage!
    
    func renderToImage() {
        // Make Rep
        let size = self.bounds.size
        let rep = makeRep(at: size)
        
        // Set Graphics State
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

        if render != nil {
            render.draw(in: self.bounds)
        }
        
        path.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        path.stroke()
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: size)
        newImage.addRepresentation(rep)
        render = newImage
    }
    
    func makeRep(at size: NSSize) -> NSBitmapImageRep {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                   pixelsWide: Int(size.width),
                                   pixelsHigh: Int(size.height),
                                   bitsPerSample: 8,
                                   samplesPerPixel: 4,
                                   hasAlpha: true,
                                   isPlanar: false,
                                   colorSpaceName: .calibratedRGB,
                                   bytesPerRow: 0,
                                   bitsPerPixel: 0)
        return rep!
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if render != nil {
            render.draw(in: self.bounds)
        }
        
        path.lineWidth = lineWidth
        drawColor.setFill()
        drawColor.setStroke()
        path.stroke()
    }
    
    // MARK: - Interactions
    func clear() {
        render = nil
        path.removeAllPoints()
        fullPath.removeAllPoints()
        display()
    }
    
    func savePoints(to dir: URL, as name: String) {
        if pointCounter != 0 {
            fullPath.append(path)
        }
        
        let cgPoints = fullPath.points
        var points = cgPoints.enumerated().compactMap {
            $0.offset % 6 == 0 ? Point(from: $0.element) : nil
        }
        center(points: &points)
        
        let jsonData = try! JSONEncoder().encode(points)
        let text = String(data: jsonData, encoding: .utf8) ?? "There was an Error Saving"
        
        let fileURL = dir.appendingPathComponent("\(name).json")
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            saveSuccess()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func saveSuccess() {
        clear()
        setBackground(to: NSColor.green.cgColor)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.setBackground(to: .white)
        }
    }
    
    func center(points: inout [Point]) {
        var x = 0.0
        var y = 0.0
        
        for point in points {
            x += point.x
            y += point.y
        }
        
        x /= Double(points.count)
        y /= Double(points.count)
        
        points = points.map { point -> Point in
            var point = point
            point.x -= x
            point.y -= y
            point.x *= 2
            point.y *= 2
            return point
        }
    }

}
