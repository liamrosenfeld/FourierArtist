/*:
 # Fourier Artist
 Hello! I'm Liam Rosenfeld. I'm a 10th grader from Florida and this is my WWDC Scholarahip appication.
 It is a Swift Playground that is able to draw paths using discrete fourier transformations.
 
 If you want to see it working, run it right away and it will draw the Swift logo, and to create your own paths just click [here](@next). But if you want to explore how this works, just keep reading.
 */

/*:
 Let's start with what Fourier transforms are. In short, they are an a collection of equations that are able to spit functions into their component trigonometric functions.
 
 This can be used for many useful products, such as spectrographs, along with some more theoretical examples, such as what you are about to see.
 */

/*:
 The standard fourter transform is:
 
 ![ft](Images/ft.jpg)
 
 But as you may have noticed, it is an infinite integral, which is a problem for computers as they don't handle infinity well.
 
 That is why this program will use the Discrete Fourier transform:
 
 ![dft](Images/dft.jpg)
 
 As you can see, this iterates a summation over a finite set instead--so it is perfect for computers.
 */

/*:
 This works because complex numbers can be expressed in polar form as:
 
 `r(cosθ + 𝓲sinθ)`
 
 And due to the nature of the complex plane, the real component acts as the x value, and the imaginary component as the y value.
 */

import Foundation

func dft(points: [Point]) -> [Wave] {
    var vectors = [Wave]() // "X" in the equation above. It's just a collection of complex vectors.
    let N = points.count
    
    for k in 0..<N {
        var complex = Complex() // real component acts as x, imaginary component acts as y
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N) // Inside the Paren
            let cPhi = Complex(re: cos(phi), im: -sin(phi)) // Inside the Brackets
            complex += points[n].complex * cPhi
        }
        
        // This Scales It Down (Not part of the original equation)
        complex.re /= Double(N)
        complex.im /= Double(N)
        
        // Calculates Atributes of Vectors
        let amp = sqrt(complex.re * complex.re + complex.im * complex.im) // Magnitude of the vector (distance formula = √(a^2 + b^2)). Later used as radius of Epicircle.
        let phase = atan2(complex.im, complex.re) // Angle from positive x-axis. Later used to place epicycles relative to eachother.
        
        // Saves it into the array
        vectors.append(Wave(freq: k, amp: amp, phase: phase))
    }
    
    return vectors
}

/*:
 The array generated can then be converted back into an equation using the inverse:
 
 ![dft](Images/inverse.jpg)
 
 Just like for the distrubuted fourier transform, the e^𝓲t can be expanded to cost+𝓲sint using Euler's identity.
 That will cause the section past the summation to be:
 
 `cos(2πkn/N)+𝓲sin(2πkn/N)`
 
 This can then be expaned to include amplitude, phase, and theta; like in what is used in the epicycle drawer.
 
 `Acos(θkn/N+p)+A𝓲sin(θkn/N+p)`
 
 As you can see, that expands the equation to support a complex vector in polar form, just like the DFT.
 That expansion is mathematically sound because:
 1. amplitude (A) is simply 'r' in the complex vector polar coordinate form
 2. phase (P) is simply the starting angle, so it is added each time the polar theta appears inside a trig function
 3. θ is a section of the 2π period, allowing it to express more than the initial value.

 Because the real component is only relevant to the horizontal equation, and the imaginary component is only relevant to the vertical component, this equation can be simplified to:
 
 `horizontal(θ) = (1/N)(Acos((θkn/N)+p)+...)`
 
 `vertical(θ)   = (1/N)(Asin((θkn/N)+p)+...)`
 
 Each point is then a cartesian coordinate `(horizontal(θ), vertical(θ))` where θ < 2π
 
 Because those are stored as cartesian coordinates, there is no reason to keep it on the a+b𝓲 (complex) plane. That allows us to drop the 𝓲.
 */

enum inverseOrientation: String {
    case horizontal = "cos"
    case vertical   = "sin"
}

//func inverseDFT(on vectors: [Wave], for orientation: inverseOrientation) -> String{
//    let N = vectors.count
//    var equation = "1/\(N) * ("
//    for (n, vector) in vectors.enumerated() {
//        let A = vector.amp
//        let k = vector.freq
//        let p = vector.phase
//
//        let inside = "θ*\(k * n / N) + \(p)"
//        let segment = "\(A)\(orientation.rawValue)(\(inside))"
//        equation += "\(segment)+"
//    }
//    return equation
//}


// We can then use that equation to fill our Scene with the points
var scene = Scene()

func applyfourier(on file: String) {
    var fouriered = dft(points: points(from: file))
    
    fouriered.sort{ $0.amp > $1.amp }
    
    scene.setPoints(to: fouriered)
}

applyfourier(on: "swiftLogo")

/*:
 If you are interested in how it draws, check out Scene.swift! It is all explained in depth there.
 (Moving the SKScene class to here would be too cluttered)
 */

// This Just Sets Observers So This Code Can React To The UI
NotificationCenter.default.addObserver(forName: .FileChanged, object: nil, queue: nil) { notification in
    let file = notification.object as! String
    applyfourier(on: file)
}

NotificationCenter.default.addObserver(forName: .InverseFourier, object: nil, queue: nil) { _ in
    print("The X Values are From: horizontal(θ) =")
//    print(inverseDFT(on: x, for: .horizontal))
    print("")
    print("The Y Values are From: vertical(θ) =")
//    print(inverseDFT(on: y, for: .vertical))
    print("")
    print("Where θ < 2π")
}

// Now lets display it!
import PlaygroundSupport
PlaygroundPage.current.liveView = ViewController(with: scene)



//: All Images Are Public Domain from Wikimedia
