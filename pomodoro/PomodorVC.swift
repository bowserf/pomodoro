import UIKit

class PomodoroVC: UIViewController {

    private struct Constants {
        static let startStopBtnSize: CGFloat = 100
        static let verticalThresholdMode: CGFloat = 200
        static let resetPositionAnimationDuration: CGFloat = 1
        static let borderButtonWidth: CGFloat = 100
        static let borderButtonHeight: CGFloat = 60
        static let leftButtonMarginBottom: CGFloat = 100
        static let rightButtonMarginBottom: CGFloat = 200
        static let borderButtonIconColor = UIColor.red
    }

    private let startStopBtn: TextAndImageAnimatedButton
    private let tomatoBackground: TomatoBackground
    private let leafView: LeafView
    private let leftButton: OneRoundBorderButton
    private let rightButton: OneRoundBorderButton

    private var tomatoBackgroundTopConstraint: NSLayoutConstraint!
    private var startStopBtnVerticalConstraint: NSLayoutConstraint!
    private var leavesHeightConstraints: NSLayoutConstraint!

    private var isStatusBarHidden: Bool = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.startStopBtn = TextAndImageAnimatedButton()
        self.startStopBtn.translatesAutoresizingMaskIntoConstraints = false

        self.tomatoBackground = TomatoBackground()
        self.tomatoBackground.translatesAutoresizingMaskIntoConstraints = false

        self.leafView = LeafView()
        self.leafView.translatesAutoresizingMaskIntoConstraints = false

        let rightIcon = UIImage(named: "Add")!.withRenderingMode(.alwaysTemplate)

        self.rightButton = OneRoundBorderButton()
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.roundBorder = .Left
        self.rightButton.setImage(rightIcon, for: .normal)
        self.rightButton.tintColor = Constants.borderButtonIconColor

        let leftIcon = UIImage(named: "Add")!.withRenderingMode(.alwaysTemplate)

        self.leftButton = OneRoundBorderButton()
        self.leftButton.translatesAutoresizingMaskIntoConstraints = false
        self.leftButton.setImage(leftIcon, for: .normal)
        self.leftButton.tintColor = Constants.borderButtonIconColor

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.startStopBtn.addTarget(self, action: #selector(onClickStartStopBtn), for: .touchDown)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initTopBar()

        self.view.addSubview(self.tomatoBackground)
        self.view.addSubview(self.leafView)
        self.view.addSubview(self.startStopBtn)
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)

        self.view.backgroundColor = UIColor.white

        // leafView constraints
        self.leavesHeightConstraints = self.leafView.heightAnchor.constraint(equalToConstant: LeafView.defaultViewHeight)
        self.leavesHeightConstraints.isActive = true
        self.leafView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.leafView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.leafView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        // startStopBtn constraints
        self.startStopBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startStopBtnVerticalConstraint = self.startStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.startStopBtnVerticalConstraint.isActive = true
        self.startStopBtn.widthAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        self.startStopBtn.heightAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true

        // tomatoBackground constraints
        self.tomatoBackgroundTopConstraint = self.tomatoBackground.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.tomatoBackgroundTopConstraint.isActive = true
        self.tomatoBackground.heightAnchor.constraint(equalToConstant: self.view.bounds.height).isActive = true
        self.tomatoBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tomatoBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        // leftButton constraints
        self.leftButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.leftButton.widthAnchor.constraint(equalToConstant: Constants.borderButtonWidth).isActive = true
        self.leftButton.heightAnchor.constraint(equalToConstant: Constants.borderButtonHeight).isActive = true
        self.leftButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.leftButtonMarginBottom).isActive = true

        // rightButton constraints
        self.rightButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.rightButton.widthAnchor.constraint(equalToConstant: Constants.borderButtonWidth).isActive = true
        self.rightButton.heightAnchor.constraint(equalToConstant: Constants.borderButtonHeight).isActive = true
        self.rightButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.rightButtonMarginBottom).isActive = true

        // pull down gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.view.addGestureRecognizer(panGesture)
    }

    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    private func initTopBar() {
        let navigationBar = self.navigationController!.navigationBar
        let calendarBtn = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                target: self,
                action: #selector(onClickTopBarCalendar))
        navigationBar.topItem!.setLeftBarButton(calendarBtn, animated: false)

        let aboutBtn = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                target: self,
                action: #selector(onClickTopBarAbout))
        navigationBar.topItem!.setRightBarButton(aboutBtn, animated: false)
    }

    private func updateNavBarAndStatusBarDisplay() {
        self.isStatusBarHidden = !self.isStatusBarHidden
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(self.isStatusBarHidden, animated: true)
    }

    @IBAction private func onClickTopBarCalendar() {
        print("onClickTopBarCalendar")
    }

    @IBAction private func onClickTopBarAbout() {
        let alert = UIAlertController(title: "Pomodoro", message: "Application developed by bowserf.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    @IBAction private func onClickStartStopBtn() {
        self.startStopBtn.updateState()
    }

    @IBAction private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let verticalTranslation = max(0, recognizer.translation(in: self.view).y)
        if (recognizer.state == UIPanGestureRecognizer.State.changed) {
            self.startStopBtnVerticalConstraint.constant = verticalTranslation
            self.tomatoBackgroundTopConstraint.constant = verticalTranslation
            self.leavesHeightConstraints.constant = LeafView.defaultViewHeight + verticalTranslation
            self.view.layoutIfNeeded()
            self.leafView.setNeedsDisplay()
        } else if (recognizer.state == UIPanGestureRecognizer.State.ended
                && verticalTranslation < Constants.verticalThresholdMode) {
            animateResetPosition()
        }
    }

    private func animateResetPosition() {
        UIView.animate(withDuration: TimeInterval(Constants.resetPositionAnimationDuration),
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.startStopBtnVerticalConstraint.constant = 0.0
                    self.tomatoBackgroundTopConstraint.constant = 0.0
                    self.leavesHeightConstraints.constant = LeafView.defaultViewHeight
                    self.view.layoutIfNeeded()
                    self.leafView.setNeedsDisplay()
                }, completion: nil)
    }

}

