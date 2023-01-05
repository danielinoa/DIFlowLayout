//
//  Created by Daniel Inoa on 9/27/22.
//

import SwiftUI
import DIFlowLayoutEngine

/// A layout where subviews are arranged horizontally and wrapped vertically,
/// similar to how text behaves in a multiline label.
/// - Note: This layout always accepts its container proposed width.
public struct DIFlowLayout: Layout {

    // Implementation Notes
    // --------------------
    // This layout works by first grouping subviews into rows based on the proposed container width,
    // subviews' intrinsic size, and spacing values.
    // Subviews, once grouped into rows, can be vertically and horizontally aligned within their row.

    private let engine: DIFlowLayoutEngine

    public typealias Direction = DIFlowLayoutEngine.Direction
    public typealias HorizontalAlignment = DIFlowLayoutEngine.HorizontalAlignment
    public typealias VerticalAlignment = DIFlowLayoutEngine.VerticalAlignment
    public typealias Layout = DIFlowLayoutEngine.Layout

    // MARK: - Lifecycle

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

    // MARK: - Layout

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        // TODO: Ensure padding is never larger than the bounds.
        let rects = subviews.map {
            let size = $0.sizeThatFits(.unspecified)
            return DIFlowLayoutEngine.Rectangle(x: .zero, y: .zero, width: size.width, height: size.height)
        }
        let proposedSize = proposal.replacingUnspecifiedDimensions(by: .zero)
        let bounds = DIFlowLayoutEngine.Rectangle(
            x: .zero, y: .zero, width: proposedSize.width, height: proposedSize.height
        )
        let layout = engine.position(of: rects, in: bounds)
        return .init(width: bounds.width, height: layout.fittingHeight)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let rects = subviews.map {
            let size = $0.sizeThatFits(.unspecified)
            return DIFlowLayoutEngine.Rectangle(x: .zero, y: .zero, width: size.width, height: size.height)
        }
        let proposedSize = proposal.replacingUnspecifiedDimensions(by: .zero)
        let bounds = DIFlowLayoutEngine.Rectangle(
            x: .zero, y: .zero, width: proposedSize.width, height: proposedSize.height
        )
        let layout = engine.position(of: rects, in: bounds)
        zip(subviews, layout.positions).forEach { subview, position in
            subview.place(
                at: .init(x: position.x, y: position.y),
                anchor: .topLeading,
                proposal: proposal
            )
        }
    }
}
