import UIKit

@IBDesignable
class TomatoBackground: UIView {

    private struct Constants {
        static let startAngle: CGFloat = -.pi / 2

        static let nbSeeds = 12
        static let anglePerSeed: CGFloat = .pi * 2 / CGFloat(nbSeeds)
        static let lineWidth: CGFloat = 2
        static let linePadding: CGFloat = 10

        static let startAlphaValueForAnimation: CGFloat = 0.5
        static let endAlphaValueForAnimation: CGFloat = 0.2
    }

    public var verticalOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var progress: CGFloat = 0 {
        didSet {
            let radian: CGFloat = CGFloat(2 * .pi * progress)
            endAngle = Constants.startAngle + radian
            setNeedsDisplay()
        }
    }

    @IBInspectable private var nbCircle = 5
    @IBInspectable private var defaultColor: UIColor = UIColor.init(red: 0.99, green: 0.34, blue: 0.31, alpha: 1.0)
    @IBInspectable private var lineColor: UIColor = UIColor.white

    private var colors: [UIColor]

    private var endAngle: CGFloat = Constants.startAngle

    override init(frame: CGRect) {
        colors = []

        super.init(frame: frame)

        self.backgroundColor = defaultColor

        computeColorsVariation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2 + verticalOffset)
        let radius: CGFloat = max(bounds.width / 2, bounds.height / 2 + verticalOffset)
        let arcWidth = radius / CGFloat(nbCircle)

        drawBackground(center: center, arcWidth: arcWidth)
        drawSeeds(center: center, arcWidth: arcWidth)
    }

    private func drawBackground(center: CGPoint, arcWidth: CGFloat) {
        var currentRadius: CGFloat = arcWidth / 2
        for i in 0..<nbCircle {
            let path = UIBezierPath(arcCenter: center,
                    radius: currentRadius,
                    startAngle: Constants.startAngle,
                    endAngle: endAngle,
                    clockwise: true)
            path.lineWidth = arcWidth
            colors[i].setStroke()
            path.stroke()
            currentRadius += arcWidth
        }
    }

    private func drawSeeds(center: CGPoint, arcWidth: CGFloat) {
        let context = UIGraphicsGetCurrentContext()!;
        context.setStrokeColor(lineColor.cgColor);
        context.setLineWidth(Constants.lineWidth);

        for i in 1...Constants.nbSeeds {
            let angleForSeed = CGFloat(i) * Constants.anglePerSeed - .pi / 2

            let endAngleDegree = radianToDegree(radian: endAngle)
            let angleForSeedDegree = radianToDegree(radian: angleForSeed)
            if (endAngleDegree < angleForSeedDegree) {
                break
            }

            let valueCos = cos(angleForSeed)
            let valueSin = sin(angleForSeed)
            let lineHeight = arcWidth / 2

            let startX = center.x + (lineHeight + Constants.linePadding) * valueCos
            let startY = center.y + (lineHeight + Constants.linePadding) * valueSin
            context.move(to: CGPoint(x: startX, y: startY))

            let endX = startX + (lineHeight - Constants.linePadding * 2) * valueCos
            let endY = startY + (lineHeight - Constants.linePadding * 2) * valueSin
            context.addLine(to: CGPoint(x: endX, y: endY))
        }

        context.strokePath()
    }

    private func radianToDegree(radian: CGFloat) -> CGFloat {
        return radian * 360 / (2 * .pi)
    }

    private func computeColorsVariation() {
        let startAlphaValue = Constants.startAlphaValueForAnimation
        let endAlphaValue = Constants.endAlphaValueForAnimation
        let stepAlphaValue = (startAlphaValue - endAlphaValue) / CGFloat(nbCircle)
        for i in 0..<nbCircle {
            let alpha: CGFloat = startAlphaValue - stepAlphaValue * CGFloat(i)
            colors.append(UIColor.init(white: 0, alpha: alpha))
        }
    }

}
