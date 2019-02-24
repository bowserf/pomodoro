import UIKit

@IBDesignable
class TextAndImageAnimatedButton: UIControl {

    private struct Constants {
        static let iconSize: CGFloat = 20

        static let rotationAnimDuration = 2.4

        static let shadowOffset = CGSize(width: 2, height: 2)
        static let shadowOpacity: Float = 2.0
        static let shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
    }

    private let text: UILabel
    private let icon: UIImageView
    private let container: UIStackView

    @IBInspectable private var circleColor: UIColor = UIColor.white
    @IBInspectable private var contentColor: UIColor = UIColor.red
    @IBInspectable private var textOn: String = "START"
    @IBInspectable private var textOff: String = "STOP"
    @IBInspectable private var imageOn: UIImage = UIImage(named: "BtnImageOn")!.withRenderingMode(.alwaysTemplate)
    @IBInspectable private var imageOff: UIImage = UIImage(named: "BtnImageOff")!.withRenderingMode(.alwaysTemplate)
    @IBInspectable private var stateOn: Bool = true

    override init(frame: CGRect) {
        text = UILabel()
        icon = UIImageView()
        container = UIStackView()

        super.init(frame: frame)

        self.addSubview(container)
        container.addArrangedSubview(text)
        container.addArrangedSubview(icon)

        // Container constraints
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        // Container properties
        container.alignment = .center
        container.axis = .vertical
        container.isUserInteractionEnabled = false

        // Text properties
        text.textColor = contentColor

        // Icon constraints
        icon.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
        icon.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
        // Icon properties
        icon.tintColor = contentColor

        updateContent()

        initShadow()
    }

    override func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use a storyboard!")
    }

    public func updateState() {
        stateOn = !stateOn
        rotateView()
    }

    private func rotateView() {
        // rotation animation clockwise
        //UIView.animate(withDuration: Constants.rotationAnimDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
        //    self.transform = CGAffineTransform(rotationAngle: .pi)
        //}, completion: { success in
        //    UIView.animate(withDuration: Constants.rotationAnimDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
        //        self.transform = CGAffineTransform(rotationAngle: .pi * 2)
        //    }, completion: { (success) in
        //        self.updateContent()
        //    })
        //})

        // rotation animation clockwise
        UIView.animateKeyframes(withDuration: Constants.rotationAnimDuration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 4.0, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 2.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 3.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.transform = CGAffineTransform(rotationAngle: .pi * 2)
            })
        }, completion: { (success) in
            self.updateContent()
        })

        // rotation animation counterclockwise
        //UIView.animateKeyframes(withDuration: Constants.rotationAnimDuration, delay: 0, options: [.calculationModeLinear], animations: {
        //    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 2.0, animations: {
        //        self.transform = CGAffineTransform(rotationAngle: .pi)
        //    })
        //    UIView.addKeyframe(withRelativeStartTime: 1.0 / 2.0, relativeDuration: 1.0 / 2.0, animations: {
        //        self.transform = CGAffineTransform(rotationAngle: -.pi * 2)
        //    })
        //}, completion: { (success) in
        //    self.updateContent()
        //})
    }

    private func updateContent() {
        if(self.stateOn) {
            text.text = textOn
            icon.image = imageOn
        } else {
            text.text = textOff
            icon.image = imageOff
        }
    }

    private func initShadow() {
        layer.masksToBounds = false
        layer.backgroundColor = circleColor.cgColor
        layer.shadowColor = Constants.shadowColor.cgColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowOpacity = Constants.shadowOpacity
    }

}
