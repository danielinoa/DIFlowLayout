//
//  Created by Daniel Inoa on 9/27/22.
//

import SwiftUI

/// A layout where subviews are arranged horizontally and wrapped vertically,
/// similar to how text behaves in a multiline label.
/// - Note: This layout always accepts its container proposed width.
public struct DIFlowLayout: Layout {

    // Implementation Notes
    // --------------------
    // This layout works by first grouping subviews into rows based on the proposed container width,
    // subviews' intrinsic size, and spacing values.
    // Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.

    /// The direction items flow within a row.
    public enum Direction {

        /// In this direction items flow from left to right.
        case forward

        /// In this direction items flow from right to left.
        case reverse
    }

    /// The horizontal alignment of items within a row.
    public enum HorizontalAlignment {
        case leading
        case center
        case trailing
    }

    /// The vertical alignment of items within a row.
    public enum VerticalAlignment {
        case top
        case center
        case bottom
        // TODO: Add baseline vertical alignment.
    }

    /// The direction items flow within a row.
    public var direction: Direction

    /// The horizontal alignment of items within a row.
    public var horizontalAlignment: HorizontalAlignment

    /// The vertical alignment of items within a row.
    public var verticalAlignment: VerticalAlignment

    /// The horizontal distance between adjacent subviews within a row.
    public var horizontalSpacing: Double

    /// The vertical distance between adjacent rows.
    public var verticalSpacing: Double

    // MARK: - Lifecycle

    public init(
        direction: Direction = .forward,
        horizontalAlignment: HorizontalAlignment = .leading,
        verticalAlignment: VerticalAlignment = .top,
        horizontalSpacing: Double = .zero,
        verticalSpacing: Double = .zero
    ) {
        self.direction = direction
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    // MARK: - Layout

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        // TODO: Ensure padding is never larger than the bounds.
        let proposedSize = proposal.replacingUnspecifiedDimensions(by: .zero)
        let bounds = CGRect(origin: .zero, size: proposedSize)
        let layout = computeLayout(in: bounds, subviews: subviews, direction: direction)
        return .init(width: layout.width, height: layout.height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let layout = computeLayout(in: bounds, subviews: subviews, direction: direction)
        layout.subviewLayouts.forEach { (subview, origin) in
            subview.place(at: origin, anchor: .topLeading,  proposal: proposal)
        }
    }

    // MARK: - Layout Calculation

    private func computeLayout(in bounds: CGRect, subviews: Subviews, direction: Direction) -> LayoutInfo {
        var subviewLayouts: [SubviewAndOrigin] = []
        let rowsLayout = rows(
            from: subviews, in: bounds, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing
        )
        for row in rowsLayout.rows {
            var leadingOffset = initialLeadingOffset(
                for: row, in: bounds, alignment: horizontalAlignment, horizontalSpacing: horizontalSpacing
            )
            let items = direction == .forward ? row.items : row.items.reversed()
            for item in items {
                let topOffset = topOffset(for: item, aligned: verticalAlignment, within: row)
                let origin = CGPoint(x: leadingOffset, y: topOffset)
                subviewLayouts.append((item.subview, origin))
                leadingOffset += item.size.width + horizontalSpacing
            }
        }
        return LayoutInfo(
            width: bounds.width,
            height: rowsLayout.totalHeight,
            subviewLayouts: subviewLayouts
        )
    }

    private func topOffset(for item: SubviewAndSize, aligned: VerticalAlignment, within row: Row) -> Double {
        let shift: Double
        switch aligned {
        case .top:
            shift = .zero
        case .center:
            shift = (row.height - item.size.height) / 2
        case .bottom:
            shift = row.height - item.size.height
        }
        return row.topOffset + shift
    }

    /// Returns the leading offset the row's first item can be placed in.
    private func initialLeadingOffset(
        for row: Row, in bounds: CGRect, alignment: HorizontalAlignment, horizontalSpacing: Double
    ) -> Double {
        let gaps: Int = row.items.count == 1 ? .zero : row.items.count - 1
        let gapsWidth = Double(gaps) * horizontalSpacing
        let remainingSpace = bounds.width - (row.subviewsWidth + gapsWidth)
        let shift: Double
        switch alignment {
        case .leading:
            shift = .zero
        case .center:
            shift = remainingSpace / 2
        case .trailing:
            shift = remainingSpace
        }
        return bounds.minX + shift
    }

    /// This function groups subviews into rows based on the available width defined by the bounds and the specified spacing.
    private func rows(
        from subviews: Subviews, in bounds: CGRect, horizontalSpacing: Double, verticalSpacing: Double
    ) -> RowsLayout {
        let subviews: [LayoutSubview] = subviews.map { $0 }
        var leadingOffset: Double = bounds.minX
        var topOffset: Double = bounds.minY
        var totalHeight: Double = .zero

        var currentRow: Row = .init()
        currentRow.topOffset = topOffset
        var rows: [Row] = [currentRow]

        for (index, subview) in subviews.enumerated() {
            let proposedSize: ProposedViewSize = .unspecified // This constant queries for the subview's ideal size.
            let subviewSize = subview.sizeThatFits(proposedSize)
            currentRow.items.append((subview, subviewSize))
            currentRow.subviewsWidth += subviewSize.width
            currentRow.height = max(currentRow.height, subviewSize.height)
            leadingOffset += subviewSize.width + horizontalSpacing
            totalHeight = max(totalHeight, topOffset + subviewSize.height)
            if let nextSubview = subviews[safe: index + 1] {
                let nextSubviewWidth = nextSubview.sizeThatFits(ProposedViewSize(bounds.size)).width
                let needsToBreakIntoNewRow = (leadingOffset + nextSubviewWidth) >= bounds.maxX
                if needsToBreakIntoNewRow {
                    leadingOffset = bounds.minX
                    totalHeight += verticalSpacing
                    topOffset = totalHeight
                    let row = Row()
                    row.topOffset = topOffset
                    rows.append(row)
                    currentRow = row
                }
            }
        }
        return (rows, totalHeight)
    }

    // MARK: - Auxiliary Types

    private class Row {

        /// The offset from the container-bounds' min-y (not necessarily zero).
        var topOffset: Double = .zero

        /// The height of the largest subview within the row.
        var height: Double = .zero

        /// The sum of all the subviews' widths. This does not include any interim spacing.
        var subviewsWidth: Double = .zero

        var items: [SubviewAndSize] = []
    }

    private struct LayoutInfo {
        let width: Double
        let height: Double
        let subviewLayouts: [SubviewAndOrigin]
    }

    private typealias RowsLayout = (rows: [Row], totalHeight: Double)
    private typealias SubviewAndSize = (subview: LayoutSubview, size: CGSize)
    private typealias SubviewAndOrigin = (subview: LayoutSubview, origin: CGPoint)
}

private extension Array {

    subscript(safe index: Index) -> Element? {
        (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
