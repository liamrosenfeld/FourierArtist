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
 The fourter transform normally seen in mathematics is the continuous one:
 
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
 
 ![inverse dft](Images/inv.jpg)
 
 Just like for the distrubuted fourier transform, the `e^(𝓲t)` can be expanded to `cos(t)+𝓲sin(t)` using Euler's identity.
 That will cause the section past the summation to be:
 
 `X[k](cos(2πkn/N)+𝓲sin(2πkn/N))`
 
 This can then be modified to include amplitude, phase, and theta.
 
 `A(cos(θk+p)+𝓲sin(θk+p))`
 
 That is mathematically sound because:
 1. amplitude (A) is simply X[k] in the original equation. It is also equal to 'r' in the complex polar form.
 2. phase (P) is the starting angle, so it is just added to the radians inside the trig function.
 3. θ is a section of the 2πn period and increases by increments of 2π/N, allowing it to replace 2πn/N.
 
 This can then be put back into context of the summation:
 
 `(1/N)∑(A(cos(θk+p)+𝓲sin(θk+p)))`
 
 `(1/N)∑(Acos(θk+p)+A𝓲sin(θk+p))`
 
 `(1/N)((Acos(θk+p)+A𝓲sin(θk+p)) + ...)`
 
 Since that equation is complex, it can be split into it's real and imaginary components:
 
 `horizontal(θ) = (1/N)(Acos((θk)+p) + ...)` (real)
 
 `vertical(θ)   = (1/N)(Asin((θk)+p) + ...)` (imaginary)
 
 Each point is then a cartesian coordinate `(horizontal(θ), vertical(θ))` where θ < 2π and theta increases in increments of 2π/N
 
 This is nearly identical to what is found in the epicycle drawer in `Scene.swift`
 */

enum inverseOrientation: String {
    case horizontal = "cos"
    case vertical   = "sin"
}

func inverseDFT(on vectors: [Wave], for orientation: inverseOrientation) -> String {
    let N = vectors.count
    var equation = "1/\(N) * ("
    for vector in vectors {
        let A = vector.amp
        let k = vector.freq
        let p = vector.phase

        let inside = "\(k)θ + \(p)"
        let segment = "\(A)*\(orientation.rawValue)(\(inside))"
        equation += "(\(segment))+"
    }
    equation+=")"
    return equation
}

/*:
 The equations generted graph a full represtation of the original pathh when plotted
 
 For example, the equations for `swiftLogo` can be plotted using matplotlib in python:
 
 ```python
 import matplotlib.pyplot as plt
 import numpy as np
 theta = 0
 x = []
 y = []
 while theta <= 2 * np.pi:
     x.append(horizontal(theta))
     y.append(vertical(theta))
     theta += (2 * np.pi) / 53 # N = 53
 plt.plot(x, y)
 plt.xscale = np.pi
 plt.title("Swift Logo")
 plt.show()
 ```
 
 That generates:
 
 ![inverse graphed](Images/invex.png)
 
 As you can see, it maintains the path with very few inconsistencies.
 */

/*:
 We can then use the dft equation to fill our Scene with the points and display them using a method nearly identical to the inverse dft
 
 If you are interested in how it draws, check out Scene.swift! It is all explained in depth there.
 
 (Having the SKScene class in here would be too cluttered)
 */

var scene = Scene()
func applyfourier(on file: String) {
    // This Gets the Points from the Selected File
    var fouriered = dft(points: points(from: file))
    
    // This Sorts the Epicyles By Amplitude (It Looks The Better Storted Largest to Smallest)
    // Because The Spicycles Stacked Are the Equilivant of Adding Trig Functions, Order Does Not Matter.
    // You can test that by changing the sort function, or removing it all together.
    fouriered.sort{ $0.amp > $1.amp }
    
    // This Sets The Epicycles to What The DFT Returned
    scene.epicycles = fouriered
}

// Load Default Path
applyfourier(on: "swiftLogo")

/*:
 Some Code Here Needs to Be Triggered By Events That Occur in the Sources Folder
 
 (such as the dropdown selecting to new file to fourier or the button printing the inverse)
 
 This Just Sets Observers So This Code Can React To The UI
 */
NotificationCenter.default.addObserver(forName: .FileChanged, object: nil, queue: nil) { notification in
    let file = notification.object as! String
    applyfourier(on: file)
}

NotificationCenter.default.addObserver(forName: .InverseFourier, object: nil, queue: nil) { _ in
    print("The X Values are From: horizontal(θ) =")
    print(inverseDFT(on: scene.epicycles, for: .horizontal))
    print("")
    print("The Y Values are From: vertical(θ) =")
    print(inverseDFT(on: scene.epicycles, for: .vertical))
    print("")
    print("Where θ < 2π increasing in increments of 2π/N")
}

//: All That's Left is Displaying It!
import PlaygroundSupport
let vc = ViewController(with: scene)
PlaygroundPage.current.liveView = vc


//: All Images Are Public Domain from Wikimedia
