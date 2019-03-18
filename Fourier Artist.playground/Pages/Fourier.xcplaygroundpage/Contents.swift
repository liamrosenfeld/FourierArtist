/*:
 # Fourier Artist
 Hello! I'm Liam Rosenfeld. I'm a 10th grader from Florida and this is my WWDC Scholarship application.
 It is a Swift Playground that is able to draw paths using discrete Fourier transformations.
 
 If you want to see it working, run it right away and it will draw the Swift logo, and to create your own paths just click [here](@next). But if you want to explore how this works, just keep reading.
 */

/*:
 Let's start with what Fourier transforms are. In short, they are a collection of equations that are able to spit functions into their component trigonometric functions.
 
 This can be used for many useful products, such as spectrographs, along with some more theoretical examples, such as what you are about to see.
 */

/*:
 The Fourier transform normally seen in mathematics is the continuous one:
 
 ![ft](Images/ft.jpg)
 
 But as you may have noticed, it is an infinite integral, which is a problem for computers as they don't handle infinity well.
 
 That is why this program will use the Discrete Fourier transform:
 
 ![dft](Images/dft.jpg)
 
 As you can see, this iterates a summation over a finite set instead--so it is perfect for computers.
 */

/*:
 Let's break the goal of the distributed Fourier transform down.
 
 The goal is to turn a collection of signals (x) into a collection of waves (X)
 
 Waves have three characteristics: amplitude, frequency, phase.
 - Amplitude is the distance between the midpoint and peak
 - Frequency is how many times the wave repeats per period
 - Phase is a horizontal translation applied to the wave (changes where it starts)
 
 Fourier transforms are able to break an equation down into its component waves.
 
 When you run the playground, you see many rotating epicycles (the circles) those are just waves expressed on a polar graph.
 
 They are all appended to the one prior because the process to display involves adding them together as vectors, and that is how vectors are added. This will be covered in more detail with the inverse distributed Fourier transform later.
 */

/*:
 To cover the implementation, let's start with the input
 
 Distributed Fourier transforms take in a series of points in the form:
 
 `[(x1, y1), (x2, y2)...]`
 
 Because points can easily be translated to complex numbers (x=real, y=imaginary) it can also be expressed as:
 
 `[x1+𝓲y1, x2+𝓲y2]`
 
 That is how they will be dealt with for the remainder of the process.
 
 The next section to cover is what will be multiplied with x[n] in the summation.
 
 As you can see in the equation above, it starts as `e^(𝓲2πkn/N)` but is then expanded to `cos(2πkn/N)+𝓲sin(2πkn/N)` using Euler's identity
 
 That can then be put into context as
 
 `X[k]=∑(x[n]+𝓲y[n])*(cos(2πkn/N)+𝓲sin(2πkn/N))`
 
 Because both the point and the e^(𝓲2πkn/N) are now complex numbers, they can be multiplied using FOIL, a concept from basic Algebra.
 
 `(a+bi)(c+di) = ac + adi + bci - bd = (ac - bd) + i(ad + bc)`
 
 In the code below, it is simply written as '*' because the operator is overloaded to do what's above in `Complex.swift`
 
 The `X[k]=∑...` means two nested for loops.
 - The outer one is from `X[k]` which iterates over k values (one for every point starting at zero), adding a new wave to X each iteration.
 - The inner one is from the `∑` which iterates over n values, adding the complex number `(x[n]+𝓲y[n])*(cos(2πkn/N)+𝓲sin(2πkn/N))` to the total each iteration.
 
 After the summation finds the final complex number it must find the properties of the wave (epicycle).
 
 That includes frequency, amplitude, and phase.
 - frequency is just `k`, as the wave is `X[k]`
 - amplitude is the magnitude of the complex number thought of as a vector. The Pythagorean Theorem is all that is required to find it
 - phase is the angle from the positive x-axis. It is found using arctan2, as that is it's defined purpose.
 
 Those are all used later when displaying
 - frequency is how many times the epicycle rotates per 2π period
 - amplitude is the radius of the epicycle
 - phase is the starting angle of the epicycle
 */

import Foundation

func dft(points: [Point]) -> [Wave] {
    var vectors = [Wave]() // "X" in the equation above. It's just a collection of complex vectors.
    let N = points.count
    
    for k in 0..<N {
        var complex = Complex() // where output of summation is stored
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N) // Inside the Paren
            let cPhi = Complex(re: cos(phi), im: -sin(phi)) // Inside the Brackets
            complex += points[n].complex * cPhi // For complex number operator overloads, see Complex.swift
        }
        
        // This Scales It Down (Not part of the original equation)
        complex.re /= Double(N)
        complex.im /= Double(N)
        
        // Calculates Atributes of Vectors
        let amp = sqrt(complex.re * complex.re + complex.im * complex.im)
        let phase = atan2(complex.im, complex.re)
        
        // Saves it into the array
        vectors.append(Wave(freq: k, amp: amp, phase: phase))
    }
    
    return vectors
}

/*:
 The array generated can then be converted back into an equation using the inverse:
 
 ![inverse dft](Images/inv.jpg)
 
 Just like for the distrubuted Fourier transform, the `e^(𝓲t)` can be expanded to `cos(t)+𝓲sin(t)` using Euler's identity.
 That will cause the section past the summation to be:
 
 `X[k](cos(2πkn/N)+𝓲sin(2πkn/N))`
 
 This can then be modified to include amplitude, phase, and theta.
 
 `A(cos(θk+p)+𝓲sin(θk+p))`
 
 That is mathematically sound because:
 - amplitude (A) is simply X[k] in the original equation. It is also equal to 'r' in the complex polar form.
 - phase (P) is the starting angle, so it is just added to the radians inside the trig function.
 - θ is a section of the 2πn period and increases by increments of 2π/N, allowing it to replace 2πn/N.
 
 This can then be put back into context of the summation:
 
 `(1/N)∑(A(cos(θk+p)+𝓲sin(θk+p)))`
 
 `(1/N)∑(Acos(θk+p)+A𝓲sin(θk+p))`
 
 `(1/N)((Acos(θk+p)+A𝓲sin(θk+p)) + ...)`
 
 Since that equation is complex, it can be split into it's real and imaginary components:
 
 `horizontal(θ) = (1/N)(Acos((θk)+p) + ...)` (real)
 
 `vertical(θ)   = (1/N)(Asin((θk)+p) + ...)` (imaginary)
 
 Each point is then a cartesian coordinate `(horizontal(θ), vertical(θ))` where θ < 2π and theta increases in increments of 2π/N
 
 In the display, a vector connects the center of each circle to a point on the circle θ radians from the positive x axis.
 That drawn vector of each epicycle is equal to the A(cos(θk+p)+𝓲sin(θk+p)) of each epicycle because they are just different ways of expressing the same vector.
 Since vectors are addded by apphending one to the other, the display also serves as a visual proof to the mathematical proof above and visa-versa.
 
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
 
 (such as the dropdown selecting to new file to Fourier or the button printing the inverse)
 
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


/*:
 ## Sources
 ### Math
 - [3blue1brown's YouTube Video](https://youtu.be/spUNpyF58BY)
 - [Better Explained's Interactive Guide](https://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/)
 - [GoldPlatedGoof's YouTube Video](https://youtu.be/2hfoX51f6sg)
 
 ### Images
 - All Equation Images Are Public Domain from Wikimedia
 - Swift Logo SVG (turned into `swiftLogo` path) from Wikimedia
 - Swift Logo mathplotlib Graph Created By Me
 */
