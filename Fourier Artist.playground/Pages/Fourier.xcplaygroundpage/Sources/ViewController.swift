//
//  ViewController.swift
//  Fourier Artist
//
//  Created by Liam on 2/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

public class ViewController : NSViewController {
    
    // MARK: - Setup
    var scene: Scene
    public init(with scene: Scene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.scene = Scene()
        super.init(coder: coder)
    }
    

    // MARK: - Interface
    var skView = SKView()
    var jsonSelector = NSPopUpButton(frame: NSRect.zero)
    
    override public func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = NSView(frame: frame)
        
        jsonSelector = createSelector()
        skView = createSKView()
        let inverseButton = createInverseButton()
        let labels = createLabels()
        
        view.addSubview(skView)
        view.addSubview(jsonSelector)
        view.addSubview(inverseButton)
        labels.forEach{ view.addSubview($0) }
        
        self.view = view
    }
    
    func createLabels() -> [NSTextField] {
        var labels = [NSTextField]()
        
        let selectorLabel = NSTextField(labelWithString: "Select Path:")
        var place = CGPoint(x: 25, y: 55)
        var size = CGSize(width: selectorLabel.frame.size.width, height: 15)
        selectorLabel.frame = NSRect(origin: place, size: size)
        labels.append(selectorLabel)
        
        let segueLabel = NSTextField(labelWithString: "and")
        place = CGPoint(x: 160, y: 30)
        size = CGSize(width: selectorLabel.frame.size.width, height: 15)
        segueLabel.frame = NSRect(origin: place, size: size)
        labels.append(segueLabel)
        
        return labels
    }
    
    func createSelector() -> NSPopUpButton {
        // Position
        let place = CGPoint(x: 20, y: 20)
        let size = CGSize(width: 135, height: 30)
        let frame = NSRect(origin: place, size: size)
        let selector = NSPopUpButton(frame: frame)
        
        // On Click
        selector.target = self
        selector.action = #selector(fileSelected)
        
        // Fill
        selector.addItem(withTitle: "swiftLogo")
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: Directories.resources, includingPropertiesForKeys: nil)
            for file in fileURLs {
                let fileName = file.deletingPathExtension().lastPathComponent
                if file.pathExtension == "json" && fileName != "swiftLogo" {
                    selector.addItem(withTitle: fileName)
                }
            }
        } catch {
            print("Error while enumerating files \(Directories.resources.path): \(error.localizedDescription)")
        }
        
        return selector
    }
    
    func createInverseButton() -> NSButton {
        let button = NSButton(title: "Print Equation", target: self, action: #selector(giveInverse))
        let place = CGPoint(x: 190, y: 20)
        let size = CGSize(width: button.frame.size.width, height: 30)
        let frame = NSRect(origin: place, size: size)
        button.frame = frame
        return button
    }
    
    func createSKView() -> SKView {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = SKView(frame: frame)
        
        // Set Size
        let sceneSize = CGSize(width: 1800, height: 1200)
        scene.size = sceneSize
        scene.scaleMode = .aspectFit
        
        // Set Properties
        view.preferredFramesPerSecond = 20 // Makes it Move Slower
        
        // Present
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    
    // MARK: - Actions
    @objc func fileSelected() {
        var notification = Notification(name: .FileChanged)
        guard let selectedPath = jsonSelector.selectedItem?.title else {
            print("No Path Selected")
            return
        }
        notification.object = selectedPath
        NotificationCenter.default.post(notification)
    }
    
    @objc func giveInverse() {
        let notification = Notification(name: .InverseFourier)
        NotificationCenter.default.post(notification)
    }
}


