/*:
 # Path Creator
 To create your own path just:
 1. run this page
 2. draw in the white box (the longer the path, the longer the calculation)
 3. name your path
 4. save your path
 
 It saves to a json file in playground's resources folder (for persistance and sharability), so if this playground is stored in a protected portion of the disk it will not work.
 
 **After you save it, just click [here](@previous) to return to the previous screen.**
 **Your new path with be listed in the drop down below `swiftLogo`.**
*/

import AppKit
import SpriteKit
import PlaygroundSupport

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
