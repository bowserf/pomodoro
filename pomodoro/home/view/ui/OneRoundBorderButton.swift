import UIKit

@IBDesignable
class OneRoundBorderButton: UIControl {

    private struct Constants {
        static let defaultRoundBorder = RoundBorder.Right
        static let horizontalMargin: CGFloat = 30

        static let shadowOffset = CGSize(width: 0, height: 2)
        static let shadowOpacity: Float = 2.0
        static let shadowColor = UIColor(white: 0.2, alpha: 0.5)
        
        static let iconColor = UIColor.init(named: "IconActionButton")!
        
        static let bgColor = UIColor.init(named: "ActionButton")!
    }

    public var roundBorder: RoundBorder = Constants.defaultRoundBorder

    private let icon: UIImageView
    
    private var roundedCornerLayer: CAShapeLayer? = nil
    
    override init(frame: CGRect) {
        self.icon = UIImageView()
        self.icon.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        self.addSubview(self.icon)

        self.icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use a storyboard!")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.icon.tintColor = Constants.iconColor

        applyRoundedCorners()

        if (self.roundBorder == RoundBorder.Left) {
            self.icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.horizontalMargin).isActive = true
        } else {
            self.icon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.horizontalMargin).isActive = true
        }
    }

    public func setIconImage(_ image: UIImage) {
        self.icon.image = image
    }

    public func rotationIcon(duration: TimeInterval) {
        let orientation: CGFloat = self.roundBorder == RoundBorder.Left ? -1 : 1
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 4.0, animations: {
                self.icon.transform = CGAffineTransform(rotationAngle: orientation * .pi / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.icon.transform = CGAffineTransform(rotationAngle: orientation * .pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 2.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.icon.transform = CGAffineTransform(rotationAngle: orientation * .pi * 3 / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 3.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.icon.transform = CGAffineTransform(rotationAngle: orientation * .pi * 2)
            })
        }, completion: nil)
    }
    
    private func applyRoundedCorners() {
        let cornerRadius = self.bounds.height / 2
        let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: computeRoundedCorners(),
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        shapeLayer.fillColor = Constants.bgColor.cgColor
        shapeLayer.shadowColor = Constants.shadowColor.cgColor
        shapeLayer.shadowOffset = Constants.shadowOffset
        shapeLayer.shadowOpacity = Constants.shadowOpacity
        
        if roundedCornerLayer != nil {
            roundedCornerLayer?.removeFromSuperlayer()
        }
        roundedCornerLayer = shapeLayer
        layer.insertSublayer(shapeLayer, at: 0)
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
