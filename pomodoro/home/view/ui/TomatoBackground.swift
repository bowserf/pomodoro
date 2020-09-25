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

        static let shadowColor = UIColor.init(white: 0.0, alpha: 0.15)
        static let shadowThickness: CGFloat = 10
    }

    public var verticalOffset: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    public var progress: CGFloat {
        set {
            if let layer = layer as? SWLayer {
                let radian: CGFloat = CGFloat(2 * .pi * newValue)
                layer.endAngle = Constants.startAngle + radian
            }
        }
        get {
            if let layer = layer as? SWLayer {
                return layer.endAngle
            }
            return 0.0
        }
    }

    override class var layerClass: AnyClass {
        return SWLayer.self
    }

    @IBInspectable private var nbCircle = 5
    @IBInspectable private var defaultColor: UIColor = UIColor.init(named: "Tomato")!
    @IBInspectable private var lineColor: UIColor = UIColor.white

    private var colors: [UIColor]

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

        drawShadow(center: center, radius: radius)
        drawBackground(center: center, arcWidth: arcWidth)
        drawSeeds(center: center, arcWidth: arcWidth)
    }

    private func drawBackground(center: CGPoint, arcWidth: CGFloat) {
        guard let swlayer = self.layer.presentation() as? SWLayer else {
            return
        }

        var currentRadius: CGFloat = arcWidth / 2
        for i in 0..<nbCircle {
            let path = UIBezierPath(arcCenter: center,
                    radius: currentRadius,
                    startAngle: Constants.startAngle,
                    endAngle: swlayer.endAngle,
                    clockwise: true)
            path.lineWidth = arcWidth
            colors[i].setStroke()
            path.stroke()
            currentRadius += arcWidth
        }
    }

    private func drawShadow(center: CGPoint, radius: CGFloat) {
        guard let swlayer = self.layer.presentation() as? SWLayer else {
            return
        }

        if swlayer.endAngle == Constants.startAngle {
            return
        }

        let context = UIGraphicsGetCurrentContext()!;

        let x0 = center.x + Constants.shadowThickness / 2 * cos(-Constants.startAngle + swlayer.endAngle)
        let y0 = center.y + Constants.shadowThickness / 2 * sin(-Constants.startAngle + swlayer.endAngle)
        let x1 = x0 + radius * cos(swlayer.endAngle)
        let y1 = y0 + radius * sin(swlayer.endAngle)

        context.move(to: CGPoint(x: x0, y: y0))
        context.addLine(to: CGPoint(x: x1, y: y1))

        context.setStrokeColor(Constants.shadowColor.cgColor);
        context.setLineWidth(Constants.shadowThickness);
        context.strokePath()
    }

    private func drawSeeds(center: CGPoint, arcWidth: CGFloat) {
        guard let swlayer = self.layer.presentation() as? SWLayer else {
            return
        }

        let context = UIGraphicsGetCurrentContext()!;
        context.setStrokeColor(lineColor.cgColor);
        context.setLineWidth(Constants.lineWidth);

        for i in 1...Constants.nbSeeds {
            let angleForSeed = CGFloat(i) * Constants.anglePerSeed - .pi / 2

            let endAngleDegree = radianToDegree(radian: swlayer.endAngle)
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

class SWLayer: CALayer {

    @NSManaged var endAngle: CGFloat

    override init() {
        super.init()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? SWLayer {
            endAngle = layer.endAngle
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override class func needsDisplay(forKey key: String) -> Bool {
        if self.isCustomAnimKey(key: key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override func action(forKey event: String) -> CAAction? {
        if SWLayer.isCustomAnimKey(key: event) {
            if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
                animation.keyPath = event
                if let pLayer = presentation() {
                    animation.fromValue = pLayer.endAngle
                }
                animation.toValue = nil
                return animation
            }
            setNeedsDisplay()
            return nil
        }
        return super.action(forKey: event)
    }

    private class func isCustomAnimKey(key: String) -> Bool {
        return key == "endAngle"
    }
}
