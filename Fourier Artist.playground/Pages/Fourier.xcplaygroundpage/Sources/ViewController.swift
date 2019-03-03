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
    var jsonSelector = NSPopUpButton(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
    override public func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = NSView(frame: frame)
        
        fillSelector()
        skView = createSKView()
        
        view.addSubview(skView)
        view.addSubview(jsonSelector)
        self.view = view
    }
    
    func fillSelector() {
        jsonSelector.target = self
        jsonSelector.action = #selector(fileSelected)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: Directories.resources, includingPropertiesForKeys: nil)
            for file in fileURLs {
                if file.pathExtension == "json" {
                    jsonSelector.addItem(withTitle: file.deletingPathExtension().lastPathComponent)
                }
            }
        } catch {
            print("Error while enumerating files \(Directories.resources.path): \(error.localizedDescription)")
        }
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
    
    @objc func fileSelected() {
        var notification = Notification(name: Notification.Name("FileChanged"))
        notification.object = jsonSelector.selectedItem?.title ?? "swiftLogo"
        NotificationCenter.default.post(notification)
    }
}


