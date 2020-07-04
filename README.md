# FGED.Mathematics

FGED.Mathematics is a cross-platform game engine math library based on Eric Lengyel's Foundations of Game Engine Development Volume 1: Mathematics. The sample code in the book is written in C++, so this library represents a number of choices made on my part in porting that sample code to Swift. 

## Why Swift?

A number of things are falling into place that are making Swift a very attractive choice for computer graphics work, especially if you are determined to write everything from scratch in order to figure out how it all works! Over the last couple of years Swift has added support for SIMD types, which is interesting for performing work on the CPU. Swift is also making strides in the realm of numerical computing. Last year saw the introduction of a new Swift Numerics package, which puts all the essential math functionality in the hands of developers. Swift is also being driven by the machine learning community (Google in particular) in very interesting ways. Right now the Swift for Tensorflow team is adding support for first class auto-differentiation to the language. Another team is developing an intermediate representation (IR) that can be mapped to multiple domains, including linear algebra. This project, called MLIR, seems poised to pave the way for heterogeneous computing with Swift (at least if you're a compiler hacker!) Finally, Swift is intended to be a systems programming language, so it seems like a good candidate for CG, which requires as much performance as it can get.

## Learning Game Engine Programming

Having a cross-platform library for game maths is an important first step in creating a cross-platform game engine in Swift. This library is the first in a planned series of libraries that, when used together, can be used to create a game engine. My plan is to follow along in the series Foundations of Game Engine Development being written by Eric Lengyel. Each volume in that series tackles the material required to build a subsystem in a game engine. By porting the sample code, I'm gaining a deeper understanding than I would by simply reading along, or typing in the code. 

Volume 2: Rendering will represent a significant engineering challenge to me, since I'll need to figure out the best way to abstract the graphics API.  

## What's in it?

- Vector3: 3-dimensional vectors, with scalar and vector addition and subtraction, dot product, cross product, triple scalar product, and point-wise multiplication.
- Matrix3D: 3x3 matrices, with support for matrix addition, subtraction, multiplication, inverses, matrix-vector multiplication, and transform matrices.

## Design Choices

This section documents some of the major design decisions that were made while writing the library.

### Generics

I wanted this math library to support multiple floating point types. The recent introduction of Swift Numerics provided the perfect foundation for this. By constraining the floating point types to the new Real protocol, this library will be able to provide support for 32-bit and 64-bit floating point types as of Swift 5.2, and will pick up 16-bit floats in Swift 5.3 when Float16 lands.

### SIMD Backing

Eric's C++ code uses a wonderfully straightforward approach to small vectors, laying out a clean struct with fields for each component. I really like this style of programming, since it lets you reason about the memory layout very easily. As an experiment I've chosen to back vectors by an internal SIMD3<T> member. As I understand it, this isn't the best way to leverage SIMD, since you end up with a mixture of SIMD and traditional instructions that are interspersed, but I wanted to see how this played out. So far I haven't looked at the generated code, or done performance testing, so the experiment is very much still under way. 
