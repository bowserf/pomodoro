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
        static let timerTextSizeTimerMode = UIFont.systemFont(ofSize: 55, weight: .bold)
        static let timerTextSizeStandByMode = UIFont.systemFont(ofSize: 115, weight: .bold)

        static let timerNameTextColor = UIColor.white
        static let timerNameTextSize = UIFont.systemFont(ofSize: 30, weight: .bold)

        static let underlineColor = UIColor.white
        static let underlineStrokeWidth: CGFloat = 5

        static let unityColor = UIColor.white
        static let unityTextSize = UIFont.systemFont(ofSize: 12, weight: .bold)

        static let animationDuration = 0.6
    }

    public static let defaultViewHeight: CGFloat = 300

    public var listener: LeafViewListener?

    @IBInspectable private var borderColor: UIColor = UIColor.white
    @IBInspectable private var leafColor: UIColor = UIColor.init(red: 0.36, green: 0.78, blue: 0.53, alpha: 1.0)

    private let timeTimerMode: UILabel
    private let underlineTimerMode: UIView

    private let timeStandByMode: UILabel
    private let underlineStandByMode: UIView

    private let timerNameBtn: UIButton
    private let minute: UILabel

    private var timeTimerModeTopConstraint: NSLayoutConstraint!
    private var timeStandByModeTopConstraint: NSLayoutConstraint!

    private var timer: String?

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
        self.timerNameBtn.setTitle(self.timer, for: .normal)
        self.timerNameBtn.setTitleColor(Constants.timerNameTextColor, for: .normal)
        self.timerNameBtn.titleLabel?.font = Constants.timerNameTextSize
        self.timerNameBtn.setImage(UIImage(named: "Edit"), for: .normal)
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
        self.minute.topAnchor.constraint(equalTo: self.timeStandByMode.bottomAnchor, constant: CGFloat(-10)).isActive = true
        self.minute.rightAnchor.constraint(equalTo: self.timeStandByMode.rightAnchor).isActive = true

        //-----------
        // TIMER MODE
        //-----------

        // time timer mode constraints
        self.timeTimerMode.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeTimerModeTopConstraint = self.timeTimerMode.topAnchor.constraint(equalTo: self.topAnchor)
        self.timeTimerModeTopConstraint.isActive = true

        // underline timer mode constraints
        self.underlineTimerMode.topAnchor.constraint(equalTo: self.timeTimerMode.bottomAnchor).isActive = true
        self.underlineTimerMode.heightAnchor.constraint(equalToConstant: Constants.underlineStrokeWidth).isActive = true
        self.underlineTimerMode.leftAnchor.constraint(equalTo: self.timeTimerMode.leftAnchor).isActive = true
        self.underlineTimerMode.rightAnchor.constraint(equalTo: self.timeTimerMode.rightAnchor).isActive = true

        // timerName constraints
        self.timerNameBtn.bottomAnchor.constraint(equalTo: self.underlineTimerMode.bottomAnchor).isActive = true
        self.timerNameBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
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

    public func setToTimerMode() {
        self.minute.isHidden = true
        self.underlineTimerMode.isHidden = false
        self.underlineTimerMode.alpha = 0
        self.timerNameBtn.isHidden = false
        self.timerNameBtn.alpha = 0
        self.timeStandByMode.alpha = 1
        self.timeTimerMode.alpha = 0
        self.timeTimerMode.isHidden = false
        self.timeStandByModeTopConstraint.constant = 0
        self.timeTimerModeTopConstraint.constant = CGFloat(100)
        self.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration,
                animations: {
                    self.timeStandByModeTopConstraint.constant = -CGFloat(100)
                    self.timeTimerModeTopConstraint.constant = 0
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

    public func setToStandByMode() {
        self.minute.isHidden = false
        self.underlineStandByMode.isHidden = false
        self.underlineStandByMode.alpha = 0
        self.timeStandByMode.isHidden = false
        self.timeStandByMode.alpha = 0
        self.timeStandByModeTopConstraint.constant = -CGFloat(100)
        self.timerNameBtn.alpha = 1
        self.timeTimerMode.alpha = 1
        self.timeTimerModeTopConstraint.constant = 0
        self.layoutIfNeeded()
        UIView.animate(withDuration: Constants.animationDuration,
                animations: {
                    self.timeStandByModeTopConstraint.constant = 0
                    self.timeTimerModeTopConstraint.constant = CGFloat(100)
                    self.timeStandByMode.alpha = 1
                    self.timeTimerMode.alpha = 0
                    self.timerNameBtn.alpha = 0
                    self.underlineStandByMode.alpha = 1
                    self.underlineTimerMode.alpha = 0
                    self.layoutIfNeeded()
                }, completion: { _ in
            self.timerNameBtn.isHidden = true
            self.timeTimerMode.isHidden = true
            self.underlineTimerMode.isHidden = true
        })
    }

    public func setTimer(timer: String) {
        self.timer = timer
        self.timerNameBtn.setTitle(timer, for: .normal)
    }

    public func showCurrentTime(time: String) {
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
