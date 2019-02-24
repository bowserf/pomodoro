import UIKit

@IBDesignable
class OneRoundBorderButton: UIButton {

    private struct Constants {
        static let defaultRoundBorder = RoundBorder.Right
        static let bgColor = UIColor.white
    }

    public var roundBorder: RoundBorder = Constants.defaultRoundBorder

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = Constants.bgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use a storyboard!")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyRoundedCorners()
    }

    private func applyRoundedCorners() {
        let cornerRadius = self.bounds.height / 2
        let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: computeRoundedCorners(),
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }

    private func computeRoundedCorners() -> UIRectCorner {
        var roundedCorners: UIRectCorner
        if (roundBorder == RoundBorder.Left) {
            roundedCorners = [.topLeft, .bottomLeft]
        } else {
            roundedCorners = [.topRight, .bottomRight]
        }
        return roundedCorners
    }
}

enum RoundBorder {
    case Left
    case Right
}
