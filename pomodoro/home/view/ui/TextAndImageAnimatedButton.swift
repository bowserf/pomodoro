import UIKit

@IBDesignable
class TextAndImageAnimatedButton: UIControl {

    private struct Constants {
        static let iconSize: CGFloat = 20

        static let rotationAnimDuration = 0.5

        static let textFont = UIFont(name: "FantasqueSansMono-Bold", size: 20)!

        static let shadowOffset = CGSize(width: 2, height: 2)
        static let shadowOpacity: Float = 2.0
        static let shadowColor = UIColor(white: 0.2, alpha: 0.5)
        
        static let textColor =  UIColor.init(named: "TextActionButton")!
        static let iconColor = UIColor.init(named: "IconActionButton")!
        static let circleColor = UIColor.init(named: "ActionButton")!
    }

    private let text: UILabel
    private let icon: UIImageView
    private let container: UIStackView

    @IBInspectable private var circleColor: UIColor!
    @IBInspectable private var textOn: String = "START"
    @IBInspectable private var textOff: String = "STOP"
    @IBInspectable private var imageOn: UIImage = UIImage(named: "BtnImageOn")!.withRenderingMode(.alwaysTemplate)
    @IBInspectable private var imageOff: UIImage = UIImage(named: "BtnImageOff")!.withRenderingMode(.alwaysTemplate)
    @IBInspectable private var stateOn: Bool = true

    override init(frame: CGRect) {
        self.text = UILabel()
        self.text.font = Constants.textFont

        self.icon = UIImageView()
        self.icon.contentMode = .scaleToFill

        self.container = UIStackView()
        self.container.translatesAutoresizingMaskIntoConstraints = false
        self.container.alignment = .center
        self.container.axis = .vertical
        self.container.isUserInteractionEnabled = false

        super.init(frame: frame)

        self.addSubview(self.container)
        self.container.addArrangedSubview(self.text)
        self.container.addArrangedSubview(self.icon)

        // Container constraints
        self.container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        // Icon constraints
        self.icon.widthAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true
        self.icon.heightAnchor.constraint(equalToConstant: Constants.iconSize).isActive = true

        updateContent()
    }

    override func layoutSubviews() {
        self.text.textColor = Constants.textColor
        self.icon.tintColor = Constants.iconColor
        self.circleColor = Constants.circleColor
        
        self.layer.cornerRadius = self.bounds.width / 2
        
        initShadow()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use a storyboard!")
    }

    public func setStartMode() {
        if !self.stateOn {
            self.stateOn = true
            rotateView()
        }
    }

    public func setStopMode() {
        if self.stateOn {
            self.stateOn = false
            rotateView()
        }
    }

    private func rotateView() {
        UIView.animateKeyframes(withDuration: Constants.rotationAnimDuration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0 / 4.0, animations: {
                self.container.transform = CGAffineTransform(rotationAngle: .pi / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.container.transform = CGAffineTransform(rotationAngle: .pi)
            })
            UIView.addKeyframe(withRelativeStartTime: 2.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.container.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 3.0 / 4.0, relativeDuration: 1.0 / 4.0, animations: {
                self.container.transform = CGAffineTransform(rotationAngle: .pi * 2)
            })
        }, completion: { (success) in
            self.updateContent()
        })
    }

    private func updateContent() {
        if (self.stateOn) {
            self.text.text = self.textOn
            self.icon.image = self.imageOn
        } else {
            self.text.text = self.textOff
            self.icon.image = self.imageOff
        }
    }

    private func initShadow() {
        self.layer.masksToBounds = false
        self.layer.backgroundColor = self.circleColor.cgColor
        self.layer.shadowColor = Constants.shadowColor.cgColor
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.shadowOpacity = Constants.shadowOpacity
    }

}
