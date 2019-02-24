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
    
    var skView = SKView()
    var jsonSelector = NSPopUpButton(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 50)))
    
    override public func loadView() {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = NSView(frame: frame)
        
        fillSelector()
        skView = createSKView(pointsFile: jsonSelector.selectedItem?.title ?? "swiftLogo")
        
        view.addSubview(skView)
        view.addSubview(jsonSelector)
        self.view = view
    }
    
    func fillSelector() {
        jsonSelector.target = self
        jsonSelector.action = #selector(updatePointFile)
        
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
    
    func createSKView(pointsFile: String) -> SKView {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 900, height: 600))
        let view = SKView(frame: frame)
        
        // Load the SKScene
        let sceneSize = CGSize(width: 1800, height: 1200)
        let scene = Scene()
        scene.pointsFile = pointsFile
        scene.size = sceneSize
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFit
        
        // Present the scene
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        
        // REMOVE LATER
        view.showsFPS = true
        view.showsNodeCount = true
        // END REMOVE LATER
        
        return view
    }
    
    @objc func updatePointFile() {
        let file = jsonSelector.selectedItem?.title ?? "swiftLogo"
        let scene = skView.scene as! Scene
        scene.pointsFile = file
    }
}

