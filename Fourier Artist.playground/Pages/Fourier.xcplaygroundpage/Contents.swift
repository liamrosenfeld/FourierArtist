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
 The standard fourter transform is:
 
 ![ft](Images/ft.jpg)
 
 But as you may have noticed, it is an infinite intgral, which it a problem for computers as they don't handle infinity well.
 
 That is why this program will using the Discrete Fourier transform:
 
 ![dft](Images/dft.jpg)
 
 As you can see, this iterates a summation over a finite set instead--so it is perfect for computers.
 */

import Foundation

func dft(x: [Double]) -> [ComplexVector] {
    var vectors = [ComplexVector]() // "X" in the equation above. It's just a collection of complex vectors.
    let N = x.count
    
    for k in 0..<N {
        var re = 0.0 // real component of the dft equation above, it will act as the x coordinate
        var im = 0.0 // imaginary component of the dft equation above, it will act as the y coordinate
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N) // This is shared between both sections of the calculation
            re += x[n] * cos(phi) // This is the cartesian complex -> polar complex equation...
            im -= x[n] * sin(phi) // ...which is how it is drawn later (theta = time)
        }
        
        // This Scales It Down (Not part of the original equation)
        re /= Double(N)
        im /= Double(N)
        
        // Calculates Atributes of Vectors
        let amp = sqrt(re * re + im * im) // Magnitude of the vector (distance formula = √(a^2 + b^2)). Later used as radius of Epicircle.
        let phase = atan2(im, re) // Angle from positive x-axis. Later used to place epicycles relative to eachother.
        
        // Saves it into the array
        vectors.append(ComplexVector(re: re, im: im, freq: k, amp: amp, phase: phase))
    }
    
    return vectors
}

/*:
 The array generated can then be converted back into an equation using the inverse:
 
 ![dft](Images/dft.jpg)
 
 Just like for the distrubuted fourier transform, the e^(𝓲...) can be expanded using Euler's identity.
 That will cause the section past the summation to be:
 
 cos(2πkn/N)+𝓲sin(2πkn/N)
 
 This can then be expaned to include amplitude, phase, and theta; like in what is used in the epicycle drawer
 
 Acos(θkn/N+p)+A𝓲sin(θkn/N+p)
 
 That expansion is mathematically sound because:
 1. amplitude (A) is simply 'r' in the expanded polar coordinate form
 2. phase (P) is simply the starting angle, so it is added each time the polar theta appears inside a trig function
 3. θ is a section of the 2π period, allowing it to express more than the initial value.
 */

func inverseDFT(on vectors: [ComplexVector]) -> String{
    let N = vectors.count
    var equation = "1/\(N) * "
    for (n, vector) in vectors.enumerated() {
        let A = vector.amp
        let k = vector.freq
        let p = vector.phase
        
        let inside = "θ*\(k * n / N) + \(p)"
        let segment = "\(A)cos(\(inside))+\(A)𝓲sin(\(inside)"
        equation += "(\(segment))"
    }
    return equation
}


// We can then use that equation to fill our Scene with the points
var scene = Scene()
var x = [ComplexVector]()
var y = [ComplexVector]()

func applyfourier(on file: String) {
    let (xValues, yValues) = pointValues(from: file)
    
    x = dft(x: xValues)
    y = dft(x: yValues)
    
    x.sort{ $0.amp > $1.amp }
    y.sort{ $0.amp > $1.amp }
    
    scene.setPoints(to: ComplexVectorSet(x, y))
}

applyfourier(on: "swiftLogo")

/*:
 If you are interested in how it draws, check out Scene.swift! It is all explained in depth there.
 (Moving the SKScene class to here would be too cluttered)
 */

// Now we just have to do set observers so this code can react to the UI
NotificationCenter.default.addObserver(forName: .FileChanged, object: nil, queue: nil) { notification in
    let file = notification.object as! String
    applyfourier(on: file)
}

NotificationCenter.default.addObserver(forName: .InverseFourier, object: nil, queue: nil) { _ in
    print("The X Values are The Real Values From: horizontal(θ) =")
    print(inverseDFT(on: x))
    print("")
    print("The Y Values are The Complex Values From: vertical(θ) =")
    print(inverseDFT(on: y))
    print("")
    print("Where θ < 2π")
}

// Now lets display it!
import PlaygroundSupport
PlaygroundPage.current.liveView = ViewController(with: scene)



//: All Images Are Public Domain from Wikimedia
