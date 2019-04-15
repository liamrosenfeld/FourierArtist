/*:
 # Fourier Artist
 Hello! I'm Liam Rosenfeld. I'm a 10th grader from Florida and this is my WWDC Scholarship application.
 It is a Swift Playground that is able to draw paths using discrete Fourier transformations.
 
 If you want to see it working, run the playground right away and it will draw the Swift logo in the live view. But if you want a full explanation on how this works, just keep reading or skip down to the code.
 
 **To create your own paths, click [here](@next) and follow the instructions on the new page.**
 */

/*:
 ## Fourier Transforms
 
 Let's start with a general explantion of Fourier transforms. In short, they are a collection of equations that are able to split functions into their component trigonometric functions.
 
 This can be used for many useful products, such as spectrographs, along with some more theoretical examples, such as what you are about to see (points -> component functions).
 */

/*:
 The Fourier transform normally seen in mathematics is the continuous one:
 
 ![ft](Images/ft.jpg)
 
 But as you may have noticed, it is an infinite integral, which is a problem for computers as they don't handle infinity well.
 
 That is why this program will use the Discrete Fourier Transform (DFT):
 
 ![dft](Images/dft.jpg)
 
 As you can see, this iterates a summation over a finite set instead--so it is perfect for computers.
 */

/*:
 ## Discrete Fourier Transform
 
 Let's break the goal of the Discrete Fourier transform down.
 
 The goal is to turn a collection of signals (x) into a collection of waves (X)
 
 Waves have three characteristics: amplitude, frequency, and phase.
 - Amplitude is the distance between the midpoint and peak
 - Frequency is how many times the wave repeats per period
 - Phase is a horizontal translation applied to the wave (changes where it starts)
 
 Fourier transforms are able to break an equation down into its component waves.
 
 When you run the playground, you see many rotating epicycles (the circles) those are just waves expressed on a polar graph.
 
 The epicycles are attached to the one prior at the point where the line intersects with the circle. That is because the epicycles are just an extended visualation of rotating vectors, and vectors are added by attaching their endpoints together. The displaying epicycles will be covered in more detail later with the Inverse Discrete Fourier Transform.
 */

/*:
 To cover the implementation, let's start with the input.
 
 Distributed Fourier transforms take in an array of points in the form:
 
 `[(x1, y1), (x2, y2)...]`
 
 Because points can easily be translated to complex numbers (x=real, y=imaginary) it can also be expressed as:
 
 `[x1+𝓲y1, x2+𝓲y2]`
 
 The input will be handled in it's complex form for the entirety of the process.
 
 The next section to cover is what is inside the summation (∑).
 As you can see in the Discrete Fourier Transform equation above, the section multiplied with `x[n]` is `e^(𝓲2πkn/N)`.
 That can then be expanded using Euler's identity of `e^(𝓲t) = cos(t)+𝓲sin(t)` to:
 
 `cos(2πkn/N)+𝓲sin(2πkn/N)`
 
 When that is placed back with the points (`x[n]`) it becomes:
 
 `(x[n]+𝓲y[n])*(cos(2πkn/N)+𝓲sin(2πkn/N))`
 
 Because both sides of the multiplication sign are complex numbers, they can be multiplied using FOIL, a concept from basic Algebra.
 That looks like:
 
 `(a+bi)(c+di) = ac + adi + bci - bd = (ac - bd) + i(ad + bc)`
 
 In the code below, that FOIL is simply written as '*' because the operator is overloaded in `Complex.swift`
 
 The last section of the equation is the `X[k]=∑`, which causes two nested `for` loops
 - The outer one is from `X[k]` which iterates over k values (one for every point starting at zero), appending a new wave to the `X` array each iteration (in which one summation takes place).
 - The inner one is from the summation (`∑`) which iterates over n values, adding the result of `(x[n]+𝓲y[n])*(cos(2πkn/N)+𝓲sin(2πkn/N))` to the total complex number each iteration.
 
 After the summation finds the final complex number it must find the properties of the wave (epicycle).
 
 That includes frequency, amplitude, and phase.
 - frequency is just `k`, as the wave is `X[k]`
 - amplitude is the magnitude of the complex number thought of as a vector. The Pythagorean Theorem is all that is required to find it.
 - phase is the angle from the positive x-axis. It is found using arctan2, as that is it's defined purpose.
 
 Those are all used later when displaying
 - frequency is how many times the epicycle rotates per 2π period
 - amplitude is the radius of the epicycle
 - phase is the starting angle of the epicycle
 */

import Foundation

func dft(points: [Point]) -> [Wave] {
    var vectors = [Wave]() // "X" in the equation above.
    let N = points.count
    
    for k in 0..<N {
        var sum = Complex() // where output of summation is stored
        
        for n in 0..<N {
            let phi = (2 * Double.pi * Double(k) * Double(n)) / Double(N) // Inside the Paren
            let cPhi = Complex(re: cos(phi), im: -sin(phi)) // Inside the Brackets
            sum += points[n].complex * cPhi // For complex number operator overloads, see Complex.swift
        }
        
        // This Scales It Down (Not part of the original equation)
        sum.re /= Double(N)
        sum.im /= Double(N)
        
        // Calculates Atributes of Vectors (Used as Properties of the Wave)
        let amp = sqrt(sum.re * sum.re + sum.im * sum.im)
        let phase = atan2(sum.im, sum.re)
        
        // Saves it into the array
        vectors.append(Wave(freq: k, amp: amp, phase: phase))
    }
    
    return vectors
}

/*:
 ## Inverse Discrete Fourier Transform
 
 The array generated can then be converted back into an equation using the inverse:
 
 ![inverse dft](Images/inv.jpg)
 
 Just like for the Discrete Fourier Transform, the `e^(𝓲t)` can be expanded to `cos(t)+𝓲sin(t)` using Euler's identity.
 That will cause the section past the summation to be:
 
 `X[k](cos(2πkn/N)+𝓲sin(2πkn/N))`
 
 This can then be modified to include amplitude, phase, and theta.
 
 `A(cos(θk+p)+𝓲sin(θk+p))`
 
 That is mathematically sound because:
 - amplitude (A) is simply X[k] in the original equation. It is also equal to 'r' in the complex polar form.
 - phase (P) is the starting angle, so it is expressed by adding it to the value inside the trig function.
 - θ is a section of the 2πn period and increases by increments of 2π/N, allowing it to replace 2πn/N.
 
 This expanded complex number can then be put back into the full equation:
 
 `(1/N)∑(A(cos(θk+p)+𝓲sin(θk+p)))`
 
 `(1/N)∑(Acos(θk+p)+A𝓲sin(θk+p))`
 
 `(1/N)((Acos(θk+p)+A𝓲sin(θk+p)) + ...)`
 
 Since that equation is complex, it can be split into it's real and imaginary components:
 
 `horizontal(θ) = (1/N)(Acos((θk)+p) + ...)` (real)
 
 `vertical(θ)   = (1/N)(Asin((θk)+p) + ...)` (imaginary)
 
 Each point is then a cartesian coordinate `(horizontal(θ), vertical(θ))` where θ < 2π and increases in increments of 2π/N
 
 In the display, a vector connects the center of each epicycle to a point on the circle `θk + p` radians from the positive x axis.
 In the math above, the vector is equal to `A(cos(θk+p)+𝓲sin(θk+p))` filled with the properties of the epicycle.
 `A(cos(θk+p)+𝓲sin(θk+p))` is simply the formula for a complex number in polar form (`r(cos(θ)+𝓲sin(θ))`) but adjusted to be a point on the circle `θk + p` radians away from the positive x-axis.
 Because both of those vectors are defined excactly the same, they are proven equal.
 That equivalency allows the display to serve as a proof to the math above and visa-versa.
 
 This process below is used to generate the printed equation, but it is also nearly identical to the epicycle drawer found in `Scene.swift`
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
 When graphed in the form `(horizontal(θ), vertical(θ))`, equations trace a full representation of the original path.
 
 For example, the equations for `swiftLogo` can be plotted using `matplotlib` in python:
 
 (The equations are abstracted to horizontal(theta) and vertical(theta) for readability)
 
 ```python
 import matplotlib.pyplot as plt
 import math as m
 N = 53
 theta = 0
 x = []
 y = []
 while theta <= 2 * m.pi:
    x.append(horizontal(theta))
    y.append(vertical(theta))
    theta += (2 * m.pi) / N
 plt.plot(x, y)
 plt.xscale = m.pi
 plt.title("Swift Logo")
 plt.show()
 ```
 
 That generates:
 
 ![inverse graphed](Images/invex.png)
 
 As you can see, it maintains the path with very few inconsistencies.
 */

/*:
 ## Displaying
 
 We can then use the DFT function to fill our drawing SKScene with the points and display them using a method nearly identical to the inverse DFT.
 
 If you are interested in how it draws, check out `Scene.swift`! It is explained in depth there.
 (Having the SKScene class in here would be too cluttered)
 */

var scene = Scene()
func applyfourier(on file: String) {
    // This Gets the Points from the Selected File
    var fouriered = dft(points: points(from: file))
    
    // This Sorts the Epicyles By Amplitude (It Looks The Better Storted Largest to Smallest)
    // Because The Epicycles Stacked Are the Equilivant of Adding Trig Functions, Order Does Not Matter.
    // You can test that by changing the sort function, or removing it all together.
    fouriered.sort{ $0.amp > $1.amp }
    
    // This Sets The Epicycles to What The DFT Returned
    scene.epicycles = fouriered
}

// Load Default Path
applyfourier(on: "swiftLogo")

/*:
 Some code in this file needs to be triggered by events that occur in the `Sources` folder.
 
 (such as the dropdown selecting a new path or the button printing the inverse)
 
 This code below sets observers to do just that.
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

//: All that is left is displaying it in the Live View!
import PlaygroundSupport
let vc = ViewController(with: scene)
PlaygroundPage.current.liveView = vc


/*:
 ## Sources
 ### Math
 - [3blue1brown's YouTube Video](https://youtu.be/spUNpyF58BY)
 - [Better Explained's Interactive Guide](https://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/)
 - [GoldPlatedGoof's YouTube Video](https://youtu.be/2hfoX51f6sg)
 - And of Course... My Math Class
 
 ### Images
 - All Equation Images Are Public Domain from Wikimedia
 - Swift Logo SVG (turned into `swiftLogo` path) from Wikimedia
 - Swift Logo mathplotlib Graph Created By Me
 */
