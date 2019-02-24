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
        view.layer!.backgroundColor = .black
        
        let drawFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 500, height: 400))
        drawView.frame = drawFrame
        drawView.wantsLayer = true
        drawView.layer?.backgroundColor = .white
        
        let clearButton = NSButton(title: "Clear", target: self, action: #selector(clear))
        let clearButtonPos = NSPoint(x: 10, y: 450)
        clearButton.setFrameOrigin(clearButtonPos)
        
        let saveButton = NSButton(title: "Save Points", target: self, action: #selector(savePoints))
        let saveButtonPos = NSPoint(x: 400, y: 450)
        saveButton.setFrameOrigin(saveButtonPos)
        
        let namePos = NSPoint(x: 200, y: 450)
        let nameSize = NSSize(width: 50, height: 15)
        let nomeFrame = NSRect(origin: namePos, size: nameSize)
        nameField.frame = nomeFrame
        
        view.addSubview(drawView)
        view.addSubview(clearButton)
        view.addSubview(saveButton)
        view.addSubview(nameField)
        
        self.view = view
    }

    @objc func clear() {
        drawView.clear()
    }
    
    @objc func savePoints() {
        drawView.savePoints(to: Directories.resources, as: nameField.string)
    }
}

