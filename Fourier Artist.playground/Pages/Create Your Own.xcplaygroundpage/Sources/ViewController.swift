//
//  ViewController.swift
//  Fourier Artist
//
//  Created by Liam on 2/15/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

public class ViewController: NSViewController {
    
    var drawView = DrawView()
    var nameField = NSTextView()
    
    override public func loadView() {
        let viewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 500))
        let view = NSView(frame: viewFrame)
        view.wantsLayer = true
        
        let drawFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 400))
        drawView.frame = drawFrame
        
        let clearButton = NSButton(title: "Clear", target: self, action: #selector(clear))
        let clearButtonPos = NSPoint(x: 10, y: 400)
        clearButton.setFrameOrigin(clearButtonPos)
        
        let saveButton = NSButton(title: "Save Points", target: self, action: #selector(savePoints))
        let saveButtonPos = NSPoint(x: 400, y: 400)
        saveButton.setFrameOrigin(saveButtonPos)
        
        let namePos = NSPoint(x: 230, y: 410)
        let nameSize = NSSize(width: 75, height: 15)
        let nameFrame = NSRect(origin: namePos, size: nameSize)
        nameField.frame = nameFrame
        nameField.string = "my path"
        
        let nameLabel = NSTextField(labelWithString: "Name:")
        var labelFrame = nameFrame
        labelFrame.origin.x = labelFrame.origin.x - 50
        nameLabel.frame = labelFrame
        
        view.addSubview(drawView)
        view.addSubview(clearButton)
        view.addSubview(saveButton)
        view.addSubview(nameField)
        view.addSubview(nameLabel)
        
        self.view = view
    }

    @objc func clear() {
        drawView.clear()
    }
    
    @objc func savePoints() {
        drawView.savePoints(to: Directories.resources, as: nameField.string)
    }
}

