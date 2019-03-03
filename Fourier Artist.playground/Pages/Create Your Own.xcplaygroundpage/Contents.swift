/*:
 # Path Creator
 To create your own path just run this page, draw it in the white box, name it, and then save it.
 It saves to a json file in playground's resources folder (for persistance and sharability), so if this playground is stored in a protected portion of the disk it will not work.
 After you save it, just click [here](@previous) to return to the previous screen. Your new path with be listed in the drop down.
*/

import AppKit
import SpriteKit
import PlaygroundSupport

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
