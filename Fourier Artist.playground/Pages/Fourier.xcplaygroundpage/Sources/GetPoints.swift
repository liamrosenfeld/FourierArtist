//
//  GetPoints.swift
//  Fourier Artist
//
//  Created by Liam on 3/03/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public func points(from file: String) -> [Point] {
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
