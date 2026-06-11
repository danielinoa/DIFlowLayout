import Testing
import SwiftUI
@testable import DIFlowLayout

@MainActor
struct DIFlowLayoutTests {

    /// Renders the view through SwiftUI and returns the size it adopts under the given proposal,
    /// exercising the full `Layout` pipeline (`makeCache`, `sizeThatFits`, `placeSubviews`).
    private func renderedSize(of view: some View, proposedWidth: CGFloat? = nil) -> CGSize {
        let renderer = ImageRenderer(content: view)
        renderer.proposedSize = .init(width: proposedWidth, height: nil)
        var size: CGSize = .zero
        renderer.render { renderedSize, _ in size = renderedSize }
        return size
    }

    private func blocks(_ count: Int, width: CGFloat = 50, height: CGFloat = 20) -> some View {
        ForEach(0..<count, id: \.self) { _ in
            Color.blue.frame(width: width, height: height)
        }
    }

    @Test func wrapsIntoRowsAtProposedWidth() {
        // 5 blocks of 50×20 at width 120 → 2 per row → 3 rows → height 60.
        let view = DIFlowLayout { blocks(5) }
        #expect(renderedSize(of: view, proposedWidth: 120) == CGSize(width: 120, height: 60))
    }

    @Test func adoptsSingleRowIdealSizeWhenWidthIsUnspecified() {
        // Without a width proposal, all 5 blocks fit in one row: 250×20.
        let view = DIFlowLayout { blocks(5) }
        #expect(renderedSize(of: view) == CGSize(width: 250, height: 20))
    }

    @Test func honorsHorizontalAndVerticalSpacing() {
        // 3 blocks of 50×20, spacing 10/5, at width 120:
        // row 1 holds two blocks (50 + 10 + 50), row 2 holds one → height 20 + 5 + 20 = 45.
        let view = DIFlowLayout(horizontalSpacing: 10, verticalSpacing: 5) { blocks(3) }
        #expect(renderedSize(of: view, proposedWidth: 120) == CGSize(width: 120, height: 45))
    }

    @Test func includesSpacingInIdealWidth() {
        // 3 blocks of 50×20 with spacing 10 in a single row: 150 + 20 = 170 wide.
        let view = DIFlowLayout(horizontalSpacing: 10) { blocks(3) }
        #expect(renderedSize(of: view) == CGSize(width: 170, height: 20))
    }

    @Test func subviewsKeepTheirMeasuredSizeWithinAWideContainer() {
        // A single 50×20 block in a 400-wide proposal must not stretch the layout's height.
        let view = DIFlowLayout { blocks(1) }
        #expect(renderedSize(of: view, proposedWidth: 400) == CGSize(width: 400, height: 20))
    }
}
