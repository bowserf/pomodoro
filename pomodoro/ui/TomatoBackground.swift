import UIKit

@IBDesignable
class TomatoBackground: UIView {

    private struct Constants {
        static let startAngle: CGFloat = -.pi / 2
        static let nbSeeds = 12
        static let anglePerSeed: CGFloat = .pi * 2 / CGFloat(nbSeeds)
        static let lineWidth: CGFloat = 2
        static let linePadding: CGFloat = 10
    }

    @IBInspectable private var nbCircle = 5
    @IBInspectable private var defaultColor: UIColor = UIColor.red
    @IBInspectable private var lineColor: UIColor = UIColor.white

    private var colors: [UIColor]

    private var endAngle: CGFloat = -.pi / 2

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
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height) / 2
        let arcWidth = radius / CGFloat(nbCircle)

        drawBackground(center: center, arcWidth: arcWidth)
        drawSeeds(center: center, arcWidth: arcWidth)
    }

    public func updateView(angle: Float) {
        let radian: CGFloat = CGFloat(2 * .pi * angle / 360)
        endAngle = Constants.startAngle + radian
        setNeedsDisplay()
    }

    private func drawBackground(center: CGPoint, arcWidth: CGFloat) {
        //TODO use class member
        let endAngle: CGFloat = .pi * 3 / 2
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

        for i in 0..<Constants.nbSeeds {
            let angleForSeed = CGFloat(i) * Constants.anglePerSeed - .pi / 2

            let endAngleDegree = radianToDegree(radian: endAngle)
            let angleForSeedDegree = radianToDegree(radian: angleForSeed)
            if(endAngleDegree < angleForSeedDegree) {
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
        let startAlphaValue: CGFloat = 0.2
        let alphaRange = CGFloat(1.0 - startAlphaValue) / CGFloat(nbCircle)
        for i in 0..<nbCircle {
            let alpha: CGFloat = CGFloat((nbCircle - 1) - i) * alphaRange + startAlphaValue
            colors.append(UIColor(red: 0, green: 0, blue: 0, alpha: alpha))
        }
    }

}