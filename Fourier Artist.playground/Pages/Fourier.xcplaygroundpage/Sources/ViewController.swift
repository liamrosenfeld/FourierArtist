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
    
    // Setup
    var scene: Scene
    public init(with scene: Scene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.scene = Scene()
        super.init(coder: coder)
    }
    

    // MARK: Interface
    var skView = SKView()
    var jsonSelector = NSPopUpButton(frame: NSRect.zero)
    override public func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = NSView(frame: frame)
        
        jsonSelector = createSelector()
        skView = createSKView()
        let inverseButton = createInverseButton()
        
        view.addSubview(skView)
        view.addSubview(jsonSelector)
        view.addSubview(inverseButton)
        
        self.view = view
    }
    
    func createSelector() -> NSPopUpButton {
        let selector = NSPopUpButton(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
        selector.target = self
        selector.action = #selector(fileSelected)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: Directories.resources, includingPropertiesForKeys: nil)
            for file in fileURLs {
                if file.pathExtension == "json" {
                    selector.addItem(withTitle: file.deletingPathExtension().lastPathComponent)
                }
            }
        } catch {
            print("Error while enumerating files \(Directories.resources.path): \(error.localizedDescription)")
        }
        
        return selector
    }
    
    func createSKView() -> SKView {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = SKView(frame: frame)
        
        // Set Size
        let sceneSize = CGSize(width: 1800, height: 1200)
        scene.size = sceneSize
        scene.scaleMode = .aspectFit
        
        // Present
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        // REMOVE LATER
        view.showsFPS = true
        view.showsNodeCount = true
        // END REMOVE LATER
        
        return view
    }
    
    func createInverseButton() -> NSButton {
        let button = NSButton(title: "Print Equation", target: self, action: #selector(giveInverse))
        let place = CGPoint(x: 200, y: 20)
        let frame = NSRect(origin: place, size: button.frame.size)
        button.frame = frame
        return button
    }
    
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


