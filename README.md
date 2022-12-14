<h1 align=center>DIFlowLayout</h1>
<p align="center">
    <img src="https://user-images.githubusercontent.com/972877/192725981-022e1eae-4f2f-4065-8371-5e7fd00d425f.jpg" width="200" max-width="90%" alt=“DIFlowLayout Icon” />
</p>

**`DIFlowLayout`** is a [`SwiftUI Layout`](https://developer.apple.com/documentation/swiftui/layout) implementation where subviews are arranged horizontally and wrapped vertically, similar to how text behaves in a multiline label. 

`DIFlowLayout` works by first grouping subviews into rows based on the proposed container width, subviews' intrinsic size, and spacing values.
Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.

# Demo

https://github.com/danielinoa/DIFlowLayoutDemo

https://user-images.githubusercontent.com/972877/192718939-f07ae806-edb9-414c-b7d8-67fe1fec9479.mp4

<video autoplay loop style="width:100%; height: auto; position:absolute; z-index: -1;">
  <source src="https://user-images.githubusercontent.com/972877/192718939-f07ae806-edb9-414c-b7d8-67fe1fec9479.mp4" type="video/mp4" />
</video>

# Installation

To install using Swift Package Manager, add this to the dependencies section in your `Package.swift` file:

```swift
.package(url: "https://github.com/danielinoa/DIFlowLayout.git", .branch("main"))
```

# Contributing

Feel free to open an issue if you have questions about how to use `DIFlowLayout`, discovered a bug, or want to improve the implementation or interface.

# Credits

`DIFlowLayout` is primarily the work of [Daniel Inoa](https://github.com/danielinoa).
