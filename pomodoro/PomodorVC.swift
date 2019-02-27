import UIKit

class PomodoroVC: UIViewController {

    private struct Constants {
        static let startStopBtnSize: CGFloat = 100

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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initTopBar()

        self.view.addSubview(tomatoBackground)
        self.view.addSubview(self.leafView)
        self.view.addSubview(startStopBtn)
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)

        self.view.backgroundColor = UIColor.white

        // leafView constraints
        self.leavesHeightConstraints = leafView.heightAnchor.constraint(equalToConstant: LeafView.defaultViewHeight)
        self.leavesHeightConstraints.isActive = true
        self.leafView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.leafView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.leafView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        // startStopBtn constraints
        startStopBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startStopBtn.widthAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.heightAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.addTarget(self, action: #selector(onClickStartStopBtn), for: .touchDown)
        
        // tomatoBackground
        tomatoBackground.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tomatoBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tomatoBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tomatoBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true


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

    private func updateNavBarAndStatusBarDIsplay() {
        self.isStatusBarHidden = !self.isStatusBarHidden
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(self.isStatusBarHidden, animated: true)
    }

    @IBAction private func onClickTopBarCalendar() {
        print("onClickTopBarCalendar")
    }

    @IBAction private func onClickTopBarAbout() {
        print("onClickTopBarAbout")
    }

    @IBAction @objc private func onClickStartStopBtn() {
        startStopBtn.updateState()
    }

}

