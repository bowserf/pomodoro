import UIKit

protocol LeafViewListener {

    func onClickEditTimer(timer: String)

}

@IBDesignable
class LeafView: UIView {

    private struct Constants {
        static let lineWidth: CGFloat = 2

        static let shadowOffset: CGFloat = 10
        static let shadowColor = UIColor.init(white: 0, alpha: 0.5)

        static let verticalHighSectionHeight: CGFloat = 0.2 * defaultViewHeight
        static let verticalLowSectionHeight: CGFloat = 0.5 * defaultViewHeight

        static let horizontalRatioLowLevel: CGFloat = 1 / 17
        static let horizontalRatioMiddleLevel: CGFloat = 3 / 17

        static let timerTextColor = UIColor.white
        static let timerTextSize = UIFont.systemFont(ofSize: 55, weight: .bold)

        static let timerNameTextColor = UIColor.white
        static let timerNameTextSize = UIFont.systemFont(ofSize: 30, weight: .bold)

        static let underlineColor = UIColor.white
        static let underlineStrokeWidth: CGFloat = 5

        static let unityColor = UIColor.white
        static let unityTextSize = UIFont.systemFont(ofSize: 12, weight: .bold)
    }

    public static let defaultViewHeight: CGFloat = 300

    public var listener: LeafViewListener?

    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var leafColor: UIColor = UIColor.init(red:0.36, green:0.78, blue:0.53, alpha:1.0)

    private let time: UILabel
    private let timerNameBtn: UIButton
    private let underline: UIView
    private let minute: UILabel

    private var timerNameTopConstraint: NSLayoutConstraint!
    private var timerTopConstraint: NSLayoutConstraint!

    private var timer: String?

    override init(frame: CGRect) {
        self.underline = UIView()
        self.underline.translatesAutoresizingMaskIntoConstraints = false
        self.underline.backgroundColor = Constants.underlineColor

        self.minute = UILabel()
        self.minute.translatesAutoresizingMaskIntoConstraints = false
        //self.unity.isHidden = true
        self.minute.textColor = Constants.unityColor
        self.minute.text = "MIN"
        self.minute.font = Constants.unityTextSize
        self.minute.sizeToFit()

        self.time = UILabel()
        self.time.translatesAutoresizingMaskIntoConstraints = false
        self.time.textColor = Constants.timerTextColor
        self.time.font = Constants.timerTextSize
        self.time.text = "25:00"

        self.timerNameBtn = UIButton()
        self.timerNameBtn.translatesAutoresizingMaskIntoConstraints = false
        self.timerNameBtn.setTitle(self.timer, for: .normal)
        self.timerNameBtn.setTitleColor(Constants.timerNameTextColor, for: .normal)
        self.timerNameBtn.titleLabel?.font = Constants.timerNameTextSize
        self.timerNameBtn.setImage(UIImage(named: "Edit"), for: .normal)
        self.timerNameBtn.semanticContentAttribute = UIApplication.shared
                .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

        super.init(frame: frame)

        self.timerNameBtn.addTarget(self, action: #selector(onClickEditTimer), for: .touchUpInside)

        self.addSubview(self.time)
        self.addSubview(self.timerNameBtn)
        self.addSubview(self.underline)
        self.addSubview(self.minute)

        backgroundColor = UIColor.clear

        self.timerTopConstraint = self.time.topAnchor.constraint(equalTo: self.topAnchor)
        self.timerTopConstraint.isActive = true
        self.time.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        self.minute.topAnchor.constraint(equalTo: self.time.bottomAnchor, constant: CGFloat(-10)).isActive = true
        self.minute.rightAnchor.constraint(equalTo: self.time.rightAnchor).isActive = true

        self.underline.topAnchor.constraint(equalTo: self.minute.bottomAnchor).isActive = true
        self.underline.heightAnchor.constraint(equalToConstant: Constants.underlineStrokeWidth).isActive = true
        self.underline.leftAnchor.constraint(equalTo: self.time.leftAnchor).isActive = true
        self.underline.rightAnchor.constraint(equalTo: self.time.rightAnchor).isActive = true

        self.timerNameTopConstraint = self.timerNameBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.timerNameTopConstraint.isActive = true
        self.timerNameBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You should use Storyboard")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // timer constraints
        self.timerTopConstraint.constant = Constants.verticalLowSectionHeight / 2

        // timerNameBtn constraints
        let val = Constants.verticalHighSectionHeight + (self.bounds.height - Constants.verticalHighSectionHeight - Constants.verticalLowSectionHeight) / 2
        self.timerNameTopConstraint.constant = -val
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

    public func setTimer(timer: String) {
        self.timer = timer
        self.timerNameBtn.setTitle(timer, for: .normal)
    }

    public func showCurrentTime(time: String) {
        self.time.text = time
    }

    private func drawLeavesPath(inset: CGFloat, color: UIColor) -> UIBezierPath {
        let width = self.bounds.width
        let height = self.bounds.height

        let middleOffsetX = width * Constants.horizontalRatioMiddleLevel
        let lowOffsetX = width * Constants.horizontalRatioLowLevel

        let verticalLowSectionHeight = Constants.verticalLowSectionHeight
        let verticalMiddleSectionHeight = height - Constants.verticalHighSectionHeight
        let verticalHighSectionHeight = height

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX + lowOffsetX / 2, y: verticalLowSectionHeight - inset), radius: lowOffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: middleOffsetX + lowOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 2 + lowOffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 3 + lowOffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOffsetX, y: verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX * 4 + lowOffsetX * 1.5, y: verticalLowSectionHeight - inset), radius: lowOffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOffsetX * 2, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 5 + lowOffsetX * 2, y: verticalHighSectionHeight - inset))

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let clippingPath = path.copy() as! UIBezierPath
        clippingPath.addLine(to: CGPoint(x: width, y: 0))
        clippingPath.addLine(to: CGPoint(x: 0, y: 0))
        clippingPath.close()
        color.setFill()
        clippingPath.fill()
        context?.restoreGState()

        return path
    }

    @IBAction private func onClickEditTimer() {
        self.listener?.onClickEditTimer(timer: self.timer!)
    }

}
