# DIFlowLayout

**`DIFlowLayout`** is a [`SwiftUI Layout`](https://developer.apple.com/documentation/swiftui/layout) implementation where elements flow horizontally and wrap vertically, similar to how text behaves in a multiline label. 

`DIFlowLayout` works by first grouping subviews into rows based on the proposed container width, subviews' intrinsic size, and spacing values.
Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.

# Demo

https://github.com/danielinoa/DIFlowLayoutDemo

# Installation

To install using Swift Package Manager, add this to the dependencies section in your `Package.swift` file:

```swift
.package(url: "https://github.com/danielinoa/DIFlowLayout.git", .branch("main"))
```

# Contributing

Feel free to open an issue if you have questions about how to use `DIFlowLayout`, discovered a bug, or want to improve the implementation or interface.

# Credits

`DIFlowLayout` is primarily the work of [Daniel Inoa](https://github.com/danielinoa).
