//
//  Directories.swift
//  Fourier Artist
//
//  Created by Liam on 2/15/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

public struct Directories {
    public static var resources: URL {
        guard let url = Bundle.main.url(forResource: "markerfile", withExtension: "txt") else {
            fatalError("Shared Resources Directory Not Found")
        }
        return url.resolvingSymlinksInPath().deletingLastPathComponent()
    }
    
}
