import UIKit

@IBDesignable
class LeafView: UIView {

    private struct Constants {
        static let lineWidth: CGFloat = 2

        static let shadowOffset: CGFloat = 10
        static let shadowColor = UIColor.init(white: 0, alpha: 0.5)

        static let verticalHighSectionHeight: CGFloat = 0.2 * defaultViewHeight
        static let verticalLowSectionHeight: CGFloat = 0.4 * defaultViewHeight

        static let horizontalRatioLowLevel: CGFloat = 1 / 17
        static let horizontalRatioMiddleLevel: CGFloat = 3 / 17
    }

    public static let defaultViewHeight: CGFloat = 200

    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var leafColor: UIColor = UIColor.green

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You should use Storyboard")
    }

    override func draw(_ rect: CGRect) {
        // draw shadow
        drawLeavesPath(inset: 0, color: Constants.shadowColor)
        // draw leaves
        let path = drawLeavesPath(inset: Constants.shadowOffset, color: leafColor)
        // Draw border
        path.lineWidth = Constants.lineWidth
        UIColor.white.setStroke()
        path.stroke()
    }

    private func drawLeavesPath(inset: CGFloat, color: UIColor) -> UIBezierPath {
        let width = self.bounds.width
        let height = self.bounds.height

        let middleOffsetX = width * Constants.horizontalRatioMiddleLevel
        let lowOfffsetX = width * Constants.horizontalRatioLowLevel

        let verticalLowSectionHeight = Constants.verticalLowSectionHeight
        let verticalMiddleSectionHeight = height - Constants.verticalHighSectionHeight
        let verticalHighSectionHeight = height

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX + lowOfffsetX / 2, y: verticalLowSectionHeight - inset), radius: lowOfffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: middleOffsetX + lowOfffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 2 + lowOfffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 3 + lowOfffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOfffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOfffsetX, y: verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX * 4 + lowOfffsetX * 1.5, y: verticalLowSectionHeight - inset), radius: lowOfffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOfffsetX * 2, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 5 + lowOfffsetX * 2, y: verticalHighSectionHeight - inset))

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        var clippingPath = path.copy() as! UIBezierPath
        clippingPath.addLine(to: CGPoint(x: width, y: 0))
        clippingPath.addLine(to: CGPoint(x: 0, y: 0))
        clippingPath.close()
        color.setFill()
        clippingPath.fill()
        context?.restoreGState()

        return path
    }

}
