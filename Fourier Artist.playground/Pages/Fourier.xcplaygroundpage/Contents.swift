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

// Now lets run it!
import PlaygroundSupport
PlaygroundPage.current.liveView = ViewController()



//: All Images Are Public Domain from Wikimedia
