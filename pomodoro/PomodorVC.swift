import UIKit

class PomodoroVC: UIViewController {

    private struct Constants {
        static let startStopBtnSize: CGFloat = 100
    }

    private let startStopBtn: TextAndImageAnimatedButton
    private let tomatoBackground: TomatoBackground
    private let leafView: LeafView

    private var leavesHeightConstraints: NSLayoutConstraint!

    private var isStatusBarHidden: Bool = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.startStopBtn = TextAndImageAnimatedButton()
        self.startStopBtn.translatesAutoresizingMaskIntoConstraints = false

        self.tomatoBackground = TomatoBackground()
        self.tomatoBackground.translatesAutoresizingMaskIntoConstraints = false

        self.leafView = LeafView()
        self.leafView.translatesAutoresizingMaskIntoConstraints = false

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

