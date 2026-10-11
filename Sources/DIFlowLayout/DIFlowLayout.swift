//
//  Created by Daniel Inoa on 9/27/22.
//

import SwiftUI
import DIFlowLayoutEngine

/// A layout where subviews are arranged horizontally and wrapped vertically,
/// similar to how text behaves in a multiline label.
/// - Note: When proposed a width, this layout accepts it. When the proposed width is unspecified
///   or infinite, this layout adopts the width that fits all subviews in a single row.
public struct DIFlowLayout: SwiftUI.Layout, Sendable {

    // Implementation Notes
    // --------------------
    // This layout works by first grouping subviews into rows based on the proposed container width,
    // subviews' intrinsic size, and spacing values.
    // Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.
    // All row-grouping and positioning math is delegated to DIFlowLayoutEngine.

    private let engine: DIFlowLayoutEngine

    public typealias Direction = DIFlowLayoutEngine.Direction
    public typealias HorizontalAlignment = DIFlowLayoutEngine.HorizontalAlignment
    public typealias VerticalAlignment = DIFlowLayoutEngine.VerticalAlignment
    public typealias Layout = DIFlowLayoutEngine.Layout

    // MARK: - Lifecycle

    /// Creates a flow layout with the same horizontal and vertical spacing.
    /// - Parameter spacing: The distance between adjacent items within a row and between rows.
    public init(spacing: Double) {
        self.init(horizontalSpacing: spacing, verticalSpacing: spacing)
    }

    /// Creates a flow layout.
    /// - Parameters:
    ///   - direction: The direction items flow within a row.
    ///   - horizontalAlignment: The horizontal alignment of items within a row.
    ///   - verticalAlignment: The vertical alignment of items within a row.
    ///   - horizontalSpacing: The horizontal distance between adjacent items within a row.
    ///   - verticalSpacing: The vertical distance between adjacent rows.
    public init(
        direction: Direction = .forward,
        horizontalAlignment: HorizontalAlignment = .leading,
        verticalAlignment: VerticalAlignment = .top,
        horizontalSpacing: Double = .zero,
        verticalSpacing: Double = .zero
    ) {
        self.engine = .init(
            direction: direction,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing
        )
    }

    // MARK: - Cache

    /// Values computed in `sizeThatFits` and reused in `placeSubviews`.
    public struct Cache: Sendable {

        /// The ideal size of each subview, measured with an unspecified proposal.
        var idealSizes: [CGSize]
    }

    public func makeCache(subviews: Subviews) -> Cache {
        .init(idealSizes: subviews.map { $0.sizeThatFits(.unspecified) })
    }

    public func updateCache(_ cache: inout Cache, subviews: Subviews) {
        cache.idealSizes = subviews.map { $0.sizeThatFits(.unspecified) }
    }

    // MARK: - Layout

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
        let width = resolvedWidth(for: proposal, cache: cache)
        let bounds = DIFlowLayoutEngine.Rectangle(x: .zero, y: .zero, width: width, height: .zero)
        let layout = engine.position(of: rectangles(from: cache), in: bounds)
        return .init(width: width, height: layout.fittingHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
        let engineBounds = DIFlowLayoutEngine.Rectangle(
            x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height
        )
        let layout = engine.position(of: rectangles(from: cache), in: engineBounds)
        for (index, (subview, position)) in zip(subviews, layout.positions).enumerated() {
            subview.place(
                at: .init(x: position.x, y: position.y),
                anchor: .topLeading,
                proposal: .init(cache.idealSizes[index])
            )
        }
    }

    // MARK: - Helpers

    /// Returns the width used to group subviews into rows.
    /// A proposed width is accepted as-is. An unspecified or infinite width resolves to the
    /// ideal width, where all subviews fit in a single row.
    private func resolvedWidth(for proposal: ProposedViewSize, cache: Cache) -> Double {
        if let width = proposal.width, width.isFinite { return width }
        let itemsWidth = cache.idealSizes.map(\.width).reduce(.zero, +)
        let gapsCount = Swift.max(cache.idealSizes.count - 1, .zero)
        return itemsWidth + Double(gapsCount) * engine.horizontalSpacing
    }

    private func rectangles(from cache: Cache) -> [DIFlowLayoutEngine.Rectangle] {
        cache.idealSizes.map { .init(x: .zero, y: .zero, width: $0.width, height: $0.height) }
    }
}
