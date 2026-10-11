<h1 align=center>DIFlowLayout</h1>
<p align="center">
    <img src="https://user-images.githubusercontent.com/972877/192725981-022e1eae-4f2f-4065-8371-5e7fd00d425f.jpg" width="200" max-width="90%" alt="DIFlowLayout Icon" />
</p>
<p align="center">
    <a href="https://swiftpackageindex.com/danielinoa/DIFlowLayout"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdanielinoa%2FDIFlowLayout%2Fbadge%3Ftype%3Dswift-versions" alt="Swift versions" /></a>
    <a href="https://swiftpackageindex.com/danielinoa/DIFlowLayout"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdanielinoa%2FDIFlowLayout%2Fbadge%3Ftype%3Dplatforms" alt="Platforms" /></a>
</p>

**`DIFlowLayout`** is a [SwiftUI `Layout`](https://developer.apple.com/documentation/swiftui/layout) implementation where subviews are arranged horizontally and wrapped vertically, similar to how text behaves in a multiline label.

`DIFlowLayout` works by first grouping subviews into rows based on the proposed container width, subviews' intrinsic size, and spacing values.
Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.

# Usage

Use `DIFlowLayout` like any other SwiftUI container:

```swift
import DIFlowLayout

struct TagsView: View {

    let tags: [String]

    var body: some View {
        DIFlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.blue.opacity(0.2)))
            }
        }
    }
}
```

Use `init(spacing:)` to apply the same spacing between items and between rows. The full initializer accepts the flow direction, horizontal and vertical alignment within each row, and separate horizontal and vertical spacing:

```swift
DIFlowLayout(
    direction: .forward,          // or .reverse
    horizontalAlignment: .leading, // .leading, .center, .trailing
    verticalAlignment: .top,       // .top, .center, .bottom
    horizontalSpacing: 8,
    verticalSpacing: 8
) {
    // subviews
}
```

# Requirements

- iOS 16+, macOS 13+, Mac Catalyst 16+, tvOS 16+, watchOS 9+, visionOS 1+
- Swift 6.0+ toolchain (Xcode 16+)

# Installation

To install using Swift Package Manager, add this to the dependencies section in your `Package.swift` file:

```swift
.package(url: "https://github.com/danielinoa/DIFlowLayout.git", from: "1.1.0")
```

Or in Xcode, add the package via **File → Add Package Dependencies…** using the URL above.

# Demo

https://github.com/danielinoa/DIFlowLayoutDemo

https://user-images.githubusercontent.com/972877/192718939-f07ae806-edb9-414c-b7d8-67fe1fec9479.mp4

# Contributing

Feel free to open an issue if you have questions about how to use `DIFlowLayout`, discovered a bug, or want to improve the implementation or interface.

# Credits

`DIFlowLayout` is primarily the work of [Daniel Inoa](https://github.com/danielinoa).
