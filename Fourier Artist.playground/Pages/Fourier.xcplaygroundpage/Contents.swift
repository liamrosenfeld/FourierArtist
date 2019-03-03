/*:
 # Fourier Artist
 Hello! I'm Liam Rosenfeld. I'm a 10th grade from Florida and this is my WWDC Scholarahip appication.
 It is a Swift Playground that is able to draw glyphs using discrete fourier transformations.
 
 If you just want to see it working ou can run it and it will draw the Swift logo, and if you want to create your own just click [here](@next). But if you want to explore how this works, just keep reading.
 */

/*:
 Let's start with what exactly fourier transforms are. In short, they are a ceollection of eqations that are able to waves into their component functions.
 This can be used for many useful products, such as spectrographs... along with some more theoritical examples such as what you are about to see.
 */

/*:
 The stadard fourter transform is:
 
 ![ft](Images/ft.jpg)
 
 But as you may have noticed, it is an infinite intgral, which it a problem for computers as they don't handle infinity well.
 
 That is why this program will using the Discrete Fourier transform:
 
 ![dft](Images/dft.jpg)
 
 As you can see this uses iterates over a finite set instead, so it is perfect for computers.
 */

import Foundation

func dft(x: [Double]) -> [ComplexVector] {
    var vectors = [ComplexVector]() // "X" in the equation above
    let N = x.count
    
    for k in 0..<N {
        var re = 0.0 // real component of the dft equation above, it will act as the x coordinate
        var im = 0.0 // imaginary component of the dft equation above, it will act as the y coordinate
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N)
            re += x[n] * cos(phi)
            im -= x[n] * sin(phi)
        }
        
        // This Scales It Down
        re /= Double(N)
        im /= Double(N)
        
        let amp = sqrt(re * re + im * im)
        let phase = atan2(im, re)
        vectors.append(ComplexVector(re: re, im: im, freq: k, amp: amp, phase: phase))
    }
    
    return vectors
}

// We can then use that equation to fill our Scene with the points
var scene = Scene()
func applyfourier(on file: String) {
    let (xValues, yValues) = pointValues(from: file)
    
    var x = dft(x: xValues)
    var y = dft(x: yValues)
    
    x.sort{ $0.amp > $1.amp }
    y.sort{ $0.amp > $1.amp }
    
    scene.setPoints(to: ComplexVectorSet(x, y))
}
applyfourier(on: "swiftLogo")

// And Then Set It So It Recalculates Every Time a New Path is Selected
NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "FileChanged"), object: nil, queue: nil) { notification in
    let file = notification.object as! String
    applyfourier(on: file)
}

// Now lets display it!
import PlaygroundSupport
PlaygroundPage.current.liveView = ViewController(with: scene)



//: All Images Are Public Domain from Wikimedia
