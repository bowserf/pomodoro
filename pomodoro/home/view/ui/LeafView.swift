import UIKit

protocol LeafViewListener {
    func onClickEditTimer(pomodoroStatus: PomodoroStatus)
}

@IBDesignable
class LeafView: UIView {

    private struct Constants {
        static let fontName = "FantasqueSansMono-Bold"
        static let borderLineThickness: CGFloat = 2

        static let shadowOffset: CGFloat = 15
        static let shadowColor = UIColor.init(white: 0, alpha: 0.3)

        static let verticalProportionalHighSectionHeight: CGFloat = 0.2
        static let verticalProportionalLowSectionHeight: CGFloat = 0.5

        static let horizontalRatioLowLevel: CGFloat = 1 / 17
        static let horizontalRatioMiddleLevel: CGFloat = 3 / 17

        static let animatedLineRatioHorizontalMiddleLevel: CGFloat = 2 / 3
        static let animatedLineThickness: CGFloat = 4
        static let animateLineColor = UIColor.init(white: 1.0, alpha: 0.2)
        static let animatedLineAnimationDuration = 0.3

        static let spaceBetweenEditIconAndText = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16)

        static let timerTextColor = UIColor.white
        static var timerTextSizeTimerMode: UIFont {
            let modelScreen = DeviceConstants.deviceModelScreen()
            switch modelScreen {
            case .iPhoneX, .iPhoneXR: return UIFont(name: fontName, size: 60)!
            default: return UIFont(name: fontName, size: 40)!
            }
        }
        static var timerTextSizeStandByMode: UIFont {
            let modelScreen = DeviceConstants.deviceModelScreen()
            switch modelScreen {
            case .iPhoneX, .iPhoneXR: return UIFont(name: fontName, size: 115)!
            default: return UIFont(name: fontName, size: 85)!
            }
        }

        static let timerNameTextColor = UIColor.white
        static var timerNameTextSize: UIFont {
            let modelScreen = DeviceConstants.deviceModelScreen()
            switch modelScreen {
            case .iPhoneX, .iPhoneXR: return UIFont(name: fontName, size: 30)!
            default: return UIFont(name: fontName, size: 20)!
            }
        }
        static let timerNameTopMargin: CGFloat = 10

        static let underlineColor = UIColor.white
        static let underlineStrokeWidth: CGFloat = 5

        static let unityColor = UIColor.white
        static let unityTextSize = UIFont(name: fontName, size: 12)!

        static let animationDuration = 0.6

        static let offsetTransitionAnimation: CGFloat = 40.0

        static let strokeStartStandByMode: CGFloat = 0.35
    }

    public var listener: LeafViewListener?

    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var leafColor: UIColor = UIColor.init(named:"Leaf")!

    private let timeTimerMode: UILabel
    private let underlineTimerMode: UIView

    private let timeStandByMode: UILabel
    private let underlineStandByMode: UIView

    private let timerNameBtn: UIButton
    private let minute: UILabel

    private var timeTimerModeTopConstraint: NSLayoutConstraint!
    private var timeStandByModeTopConstraint: NSLayoutConstraint!

    private var verticalHighSectionHeight: CGFloat!
    private var verticalLowSectionHeight: CGFloat!

    private var leftAnimatedLineLayer: CAShapeLayer!
    private var rightAnimatedLineLayer: CAShapeLayer!

    private var middleAnimationStroke: CGFloat = 0

    private var areAnimatedLinesSetup = false

    private var pomodoroStatus: PomodoroStatus?

    override init(frame: CGRect) {
        self.timeTimerMode = UILabel()
        self.timeTimerMode.translatesAutoresizingMaskIntoConstraints = false
        self.timeTimerMode.textColor = Constants.timerTextColor
        self.timeTimerMode.font = Constants.timerTextSizeTimerMode

        self.underlineTimerMode = UIView()
        self.underlineTimerMode.translatesAutoresizingMaskIntoConstraints = false
        self.underlineTimerMode.backgroundColor = Constants.underlineColor

        self.timeStandByMode = UILabel()
        self.timeStandByMode.translatesAutoresizingMaskIntoConstraints = false
        self.timeStandByMode.textColor = Constants.timerTextColor
        self.timeStandByMode.font = Constants.timerTextSizeStandByMode

        self.underlineStandByMode = UIView()
        self.underlineStandByMode.translatesAutoresizingMaskIntoConstraints = false
        self.underlineStandByMode.backgroundColor = Constants.underlineColor

        self.minute = UILabel()
        self.minute.translatesAutoresizingMaskIntoConstraints = false
        self.minute.textColor = Constants.unityColor
        self.minute.text = "MIN"
        self.minute.font = Constants.unityTextSize

        self.timerNameBtn = UIButton()
        self.timerNameBtn.translatesAutoresizingMaskIntoConstraints = false
        self.timerNameBtn.isHidden = true
        self.timerNameBtn.setTitleColor(Constants.timerNameTextColor, for: .normal)
        self.timerNameBtn.titleLabel?.font = Constants.timerNameTextSize
        self.timerNameBtn.setImage(UIImage(named: "Edit"), for: .normal)
        self.timerNameBtn.imageEdgeInsets = Constants.spaceBetweenEditIconAndText
        self.timerNameBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
                ? .forceLeftToRight
                : .forceRightToLeft

        super.init(frame: frame)

        self.backgroundColor = UIColor.clear

        self.timerNameBtn.addTarget(self, action: #selector(onClickEditTimer), for: .touchUpInside)

        self.addSubview(self.timeTimerMode)
        self.addSubview(self.timeStandByMode)
        self.addSubview(self.underlineTimerMode)
        self.addSubview(self.underlineStandByMode)
        self.addSubview(self.timerNameBtn)
        self.addSubview(self.minute)

        //--------------
        // STAND BY MODE
        //--------------

        // time stand by mode constraints
        self.timeStandByMode.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeStandByModeTopConstraint = self.timeStandByMode.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        self.timeStandByModeTopConstraint.isActive = true

        // underline stand by mode constraints
        self.underlineStandByMode.topAnchor.constraint(equalTo: self.minute.bottomAnchor).isActive = true
        self.underlineStandByMode.heightAnchor.constraint(equalToConstant: Constants.underlineStrokeWidth).isActive = true
        self.underlineStandByMode.leftAnchor.constraint(equalTo: self.timeStandByMode.leftAnchor).isActive = true
        self.underlineStandByMode.rightAnchor.constraint(equalTo: self.timeStandByMode.rightAnchor).isActive = true

        // minute constraints
        self.minute.topAnchor.constraint(equalTo: self.timeStandByMode.firstBaselineAnchor).isActive = true
        self.minute.rightAnchor.constraint(equalTo: self.timeStandByMode.rightAnchor).isActive = true

        //-----------
        // TIMER MODE
        //-----------

        // time timer mode constraints
        self.timeTimerMode.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeTimerModeTopConstraint = self.timeTimerMode.firstBaselineAnchor.constraint(equalTo: self.topAnchor)
        self.timeTimerModeTopConstraint.isActive = true

        // underline timer mode constraints
        self.underlineTimerMode.topAnchor.constraint(equalTo: self.timeTimerMode.firstBaselineAnchor, constant: CGFloat(5)).isActive = true
        self.underlineTimerMode.heightAnchor.constraint(equalToConstant: Constants.underlineStrokeWidth).isActive = true
        self.underlineTimerMode.leftAnchor.constraint(equalTo: self.timeTimerMode.leftAnchor).isActive = true
        self.underlineTimerMode.rightAnchor.constraint(equalTo: self.timeTimerMode.rightAnchor).isActive = true

        // timerName constraints
        self.timerNameBtn.topAnchor.constraint(equalTo: self.underlineTimerMode.bottomAnchor, constant: Constants.timerNameTopMargin).isActive = true
        self.timerNameBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You should use Storyboard")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawAnimatedLine()
    }

    override func draw(_ rect: CGRect) {
        // draw shadow
        drawLeavesPath(inset: 0, color: Constants.shadowColor)
        // draw leaves
        let path = drawLeavesPath(inset: Constants.shadowOffset, color: leafColor)
        // Draw border
        path.lineWidth = Constants.borderLineThickness
        UIColor.white.setStroke()
        path.stroke()
    }

    func setTimerModeHeight(height: CGFloat) {
        self.verticalLowSectionHeight = height * Constants.verticalProportionalLowSectionHeight
        self.verticalHighSectionHeight = height * Constants.verticalProportionalHighSectionHeight
    }

    func setToTimerMode() {
        startLineAnimation(
                layer: leftAnimatedLineLayer,
                strokeStartFromValue: Constants.strokeStartStandByMode,
                strokeStartToValue: 0.0,
                strokeEndFromValue: 1.0,
                strokeEndToValue: middleAnimationStroke)
        startLineAnimation(
                layer: rightAnimatedLineLayer,
                strokeStartFromValue: Constants.strokeStartStandByMode,
                strokeStartToValue: 0.0,
                strokeEndFromValue: 1.0,
                strokeEndToValue: middleAnimationStroke)

        self.minute.isHidden = true
        self.underlineTimerMode.isHidden = false
        self.underlineTimerMode.alpha = 0
        self.timerNameBtn.isHidden = false
        self.timerNameBtn.alpha = 0
        self.timeStandByMode.alpha = 1
        self.timeTimerMode.alpha = 0
        self.timeTimerMode.isHidden = false
        self.timeStandByModeTopConstraint.constant = 0
        self.timeTimerModeTopConstraint.constant = self.verticalLowSectionHeight + Constants.offsetTransitionAnimation
        self.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration,
                animations: {
                    self.timeStandByModeTopConstraint.constant = -Constants.offsetTransitionAnimation
                    self.timeTimerModeTopConstraint.constant = self.verticalLowSectionHeight
                    self.timeStandByMode.alpha = 0
                    self.timeTimerMode.alpha = 1
                    self.timerNameBtn.alpha = 1
                    self.underlineStandByMode.alpha = 0
                    self.underlineTimerMode.alpha = 1
                    self.layoutIfNeeded()
                }, completion: { _ in
            self.timeStandByMode.isHidden = true
            self.underlineStandByMode.isHidden = true

        })
    }

    func setToStandByMode() {
        self.minute.isHidden = false
        self.underlineStandByMode.isHidden = false
        self.underlineStandByMode.alpha = 0
        self.timeStandByMode.isHidden = false
        self.timeStandByMode.alpha = 0
        self.timeStandByModeTopConstraint.constant = -Constants.offsetTransitionAnimation
        self.timerNameBtn.alpha = 1
        self.timeTimerMode.alpha = 1
        self.timeTimerModeTopConstraint.constant = self.verticalLowSectionHeight
        self.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration,
                animations: {
                    self.timeStandByModeTopConstraint.constant = 0
                    self.timeTimerModeTopConstraint.constant = self.verticalLowSectionHeight + Constants.offsetTransitionAnimation
                    self.timeStandByMode.alpha = 1
                    self.timeTimerMode.alpha = 0
                    self.timerNameBtn.alpha = 0
                    self.underlineStandByMode.alpha = 1
                    self.underlineTimerMode.alpha = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
            self.startLineAnimation(
                    layer: self.leftAnimatedLineLayer,
                    strokeStartFromValue: 0.0,
                    strokeStartToValue: Constants.strokeStartStandByMode,
                    strokeEndFromValue: self.middleAnimationStroke,
                    strokeEndToValue: 1.0)
            self.startLineAnimation(
                    layer: self.rightAnimatedLineLayer,
                    strokeStartFromValue: 0.0,
                    strokeStartToValue: Constants.strokeStartStandByMode,
                    strokeEndFromValue: self.middleAnimationStroke,
                    strokeEndToValue: 1.0)

            self.timerNameBtn.isHidden = true
            self.timeTimerMode.isHidden = true
            self.underlineTimerMode.isHidden = true
        })
    }

    func setPomodoro(pomodoroStatus: PomodoroStatus) {
        self.pomodoroStatus = pomodoroStatus
        self.timerNameBtn.setTitle(pomodoroStatus.pomodoro.name, for: .normal)
    }

    func showCurrentTime(time: String) {
        self.timeTimerMode.text = time
    }

    func resetCurrentTime(time: String) {
        self.timeStandByMode.text = time
    }

    private func drawLeavesPath(inset: CGFloat, color: UIColor) -> UIBezierPath {
        let width = self.bounds.width
        let height = self.bounds.height

        let middleOffsetX = width * Constants.horizontalRatioMiddleLevel
        let lowOffsetX = width * Constants.horizontalRatioLowLevel

        let verticalMiddleSectionHeight = height - self.verticalHighSectionHeight
        let verticalHighSectionHeight = height

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX, y: self.verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX + lowOffsetX / 2, y: self.verticalLowSectionHeight - inset), radius: lowOffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: middleOffsetX + lowOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 2 + lowOffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 3 + lowOffsetX, y: verticalHighSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOffsetX, y: verticalMiddleSectionHeight - inset))
        path.addLine(to: CGPoint(x: middleOffsetX * 4 + lowOffsetX, y: self.verticalLowSectionHeight - inset))
        path.addArc(withCenter: CGPoint(x: middleOffsetX * 4 + lowOffsetX * 1.5, y: self.verticalLowSectionHeight - inset), radius: lowOffsetX / 2, startAngle: -.pi, endAngle: 0, clockwise: true)
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

    private func drawAnimatedLine() {
        if areAnimatedLinesSetup {
            return
        }

        let width = self.bounds.width
        let height = self.bounds.height

        self.middleAnimationStroke = 0.5 + (Constants.shadowOffset - Constants.animatedLineThickness) / height

        let horizontalMiddleLevelWidth = Constants.horizontalRatioMiddleLevel * width
        let spaceFromBorderScreen = Constants.animatedLineRatioHorizontalMiddleLevel * horizontalMiddleLevelWidth
        let spaceFromMiddleLevel = horizontalMiddleLevelWidth - spaceFromBorderScreen

        let verticalBottomPosition = height - spaceFromMiddleLevel

        let y0 = self.verticalLowSectionHeight - self.verticalHighSectionHeight
        let y1 = self.verticalLowSectionHeight - Constants.shadowOffset
        let y2 = verticalBottomPosition - self.verticalHighSectionHeight
        let y3 = verticalBottomPosition - Constants.shadowOffset

        // left line
        let leftAnimatedLine = UIBezierPath()
        leftAnimatedLine.move(to: CGPoint(x: 0, y: y0))
        leftAnimatedLine.addLine(to: CGPoint(x: spaceFromBorderScreen, y: y1))
        leftAnimatedLine.addLine(to: CGPoint(x: spaceFromBorderScreen, y: y2))
        leftAnimatedLine.addLine(to: CGPoint(x: 0, y: y3))
        leftAnimatedLineLayer = drawAnimatedLine(leftAnimatedLine.cgPath)

        // right line
        let rightHorizontalPosition = width - spaceFromBorderScreen
        let rightAnimatedLine = UIBezierPath()
        rightAnimatedLine.move(to: CGPoint(x: width, y: y0))
        rightAnimatedLine.addLine(to: CGPoint(x: rightHorizontalPosition, y: y1))
        rightAnimatedLine.addLine(to: CGPoint(x: rightHorizontalPosition, y: y2))
        rightAnimatedLine.addLine(to: CGPoint(x: width, y: y3))
        rightAnimatedLineLayer = drawAnimatedLine(rightAnimatedLine.cgPath)

        areAnimatedLinesSetup = true
    }

    private func drawAnimatedLine(_ animatedLinePath: CGPath) -> CAShapeLayer {
        let animatedLineLayer = CAShapeLayer()
        animatedLineLayer.frame = self.bounds
        animatedLineLayer.fillColor = nil
        animatedLineLayer.path = animatedLinePath
        animatedLineLayer.lineWidth = Constants.animatedLineThickness
        animatedLineLayer.lineJoin = .round
        animatedLineLayer.strokeColor = Constants.animateLineColor.cgColor
        animatedLineLayer.strokeStart = Constants.strokeStartStandByMode
        animatedLineLayer.strokeEnd = 1

        self.layer.addSublayer(animatedLineLayer)

        return animatedLineLayer
    }

    private func startLineAnimation(layer: CAShapeLayer,
                                    strokeStartFromValue: CGFloat,
                                    strokeStartToValue: CGFloat,
                                    strokeEndFromValue: CGFloat,
                                    strokeEndToValue: CGFloat) {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = strokeStartFromValue
        strokeStartAnimation.toValue = strokeStartToValue

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = strokeEndFromValue
        strokeEndAnimation.toValue = strokeEndToValue

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = Constants.animatedLineAnimationDuration
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        // allow to keep values at the end of the animation
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards

        layer.add(animationGroup, forKey: "group_animation")
    }

    @IBAction private func onClickEditTimer() {
        self.listener?.onClickEditTimer(pomodoroStatus: self.pomodoroStatus!)
    }

}
