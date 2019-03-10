import UIKit

class PomodoroVC: UIViewController, PomodoroView {

    private struct Constants {
        static let cellIdentifier = "settings-reuseId"
        static let startStopBtnSize: CGFloat = 100
        static let verticalThresholdMode: CGFloat = 200
        static let resetPositionAnimationDuration: TimeInterval = 1
        static let transitionModeAnimationDuration: TimeInterval = 1
        static let borderButtonWidth: CGFloat = 100
        static let borderButtonHeight: CGFloat = 60
        static let borderButtonIconColor = UIColor.red
        static let animationDisplaySideButtonsDuration: TimeInterval = 0.6
        static let verticalProportionalStandByModeOffset: CGFloat = 0.3
        static let verticalProportionalTimerModeOffset: CGFloat = 0.15
        static let verticalProportionalTimerListOffset: CGFloat = 0.05
        static let leafViewProportionalHeightStandByMode: CGFloat = 0.4
        static let leafViewProportionalHeightTimerMode: CGFloat = 0.3
        static let timerTableViewWidth: CGFloat = 200
        static let timerCellHeight: CGFloat = 44
        static let timerTableViewHeight: CGFloat = 3 * Constants.timerCellHeight
        static let timerTableViewTranslation: CGFloat = 200
        static let timerCellFontSize: CGFloat = 25
        static let selectedCheck = UIImage(named: "Add")
    }

    public var presenter: PomodoroPresenter!

    private let startStopBtn: TextAndImageAnimatedButton
    private let tomatoBackground: TomatoBackground
    private let leafView: LeafView
    private let leftButton: OneRoundBorderButton
    private let rightButton: OneRoundBorderButton
    private let pomodoroTableView: UITableView

    private var leftButtonHorizontalConstraint: NSLayoutConstraint!
    private var rightButtonHorizontalConstraint: NSLayoutConstraint!

    private var tomatoBackgroundTopConstraint: NSLayoutConstraint!
    private var startStopBtnVerticalConstraint: NSLayoutConstraint!
    private var leavesHeightConstraints: NSLayoutConstraint!
    private var timerListVerticalConstraint: NSLayoutConstraint!

    private var verticalStandByModeOffset: CGFloat!
    private var verticalTimerModeOffset: CGFloat!
    private var verticalTimerListOffset: CGFloat!
    private var leafViewHeightTimerMode: CGFloat!
    private var leafViewHeightStandByMode: CGFloat!

    private var pomodoroStatusList: [PomodoroStatus]!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pomodoroTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.pomodoroTableView.translatesAutoresizingMaskIntoConstraints = false
        self.pomodoroTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        self.pomodoroTableView.tableFooterView = UIView()
        self.pomodoroTableView.backgroundColor = .clear
        self.pomodoroTableView.showsVerticalScrollIndicator = false
        self.pomodoroTableView.separatorStyle = .none

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
        self.rightButton.setIconImage(rightIcon)
        self.rightButton.tintColor = Constants.borderButtonIconColor

        let leftIcon = UIImage(named: "Add")!.withRenderingMode(.alwaysTemplate)

        self.leftButton = OneRoundBorderButton()
        self.leftButton.translatesAutoresizingMaskIntoConstraints = false
        self.leftButton.setIconImage(leftIcon)
        self.leftButton.tintColor = Constants.borderButtonIconColor

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.leafView.listener = self

        self.pomodoroTableView.dataSource = self
        self.pomodoroTableView.delegate = self

        self.startStopBtn.addTarget(self, action: #selector(onClickStartStopBtn), for: .touchDown)

        self.leftButton.addTarget(self, action: #selector(onClickDisplayTimers), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(onClickCreateTimer), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.verticalStandByModeOffset = self.view.bounds.height * Constants.verticalProportionalStandByModeOffset
        self.verticalTimerModeOffset = self.view.bounds.height * Constants.verticalProportionalTimerModeOffset
        self.verticalTimerListOffset = self.view.bounds.height * Constants.verticalProportionalTimerListOffset
        self.leafViewHeightTimerMode = self.view.bounds.height * Constants.leafViewProportionalHeightTimerMode
        self.leafViewHeightStandByMode = self.view.bounds.height * Constants.leafViewProportionalHeightStandByMode

        self.presenter.attachView(view: self)

        initTopBar()

        self.leafView.setTimerModeHeight(height: self.leafViewHeightTimerMode)
        self.tomatoBackground.verticalOffset = verticalStandByModeOffset

        self.view.addSubview(self.tomatoBackground)
        self.view.addSubview(self.leafView)
        self.view.addSubview(self.startStopBtn)
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)
        self.view.addSubview(self.pomodoroTableView)

        self.view.backgroundColor = UIColor.white

        // timer list constraints
        self.pomodoroTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.timerListVerticalConstraint = self.pomodoroTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.verticalTimerListOffset)
        self.timerListVerticalConstraint.isActive = true
        self.pomodoroTableView.widthAnchor.constraint(equalToConstant: Constants.timerTableViewWidth).isActive = true
        self.pomodoroTableView.heightAnchor.constraint(equalToConstant: Constants.timerTableViewHeight).isActive = true

        // leafView constraints
        let leafViewHeightStandByMode = self.view.bounds.height * Constants.leafViewProportionalHeightStandByMode
        self.leavesHeightConstraints = self.leafView.heightAnchor.constraint(equalToConstant: leafViewHeightStandByMode)
        self.leavesHeightConstraints.isActive = true
        self.leafView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.leafView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.leafView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

        // startStopBtn constraints
        self.startStopBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startStopBtnVerticalConstraint = self.startStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: verticalStandByModeOffset)
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
        self.leftButtonHorizontalConstraint = self.leftButton.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        self.leftButtonHorizontalConstraint.isActive = true
        self.leftButton.widthAnchor.constraint(equalToConstant: Constants.borderButtonWidth).isActive = true
        self.leftButton.heightAnchor.constraint(equalToConstant: Constants.borderButtonHeight).isActive = true
        self.leftButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.verticalStandByModeOffset).isActive = true

        // rightButton constraints
        self.rightButtonHorizontalConstraint = self.rightButton.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        self.rightButtonHorizontalConstraint.isActive = true
        self.rightButton.widthAnchor.constraint(equalToConstant: Constants.borderButtonWidth).isActive = true
        self.rightButton.heightAnchor.constraint(equalToConstant: Constants.borderButtonHeight).isActive = true
        self.rightButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.verticalTimerListOffset).isActive = true

        // pull down gesture
        //let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        //self.view.addGestureRecognizer(panGesture)
    }

    override var prefersStatusBarHidden: Bool {
        return self.presenter.isNavigationAndStatusBarDisplayed()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    public func showAboutDialog() {
        let alert = UIAlertController(title: "Pomodoro", message: "Application developed by bowserf.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    public func showNavigationAndStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public func hideNavigationAndStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    public func showSideButtons() {
        self.leftButton.rotationIcon(duration: Constants.animationDisplaySideButtonsDuration)
        self.rightButton.rotationIcon(duration: Constants.animationDisplaySideButtonsDuration)
        UIView.animate(withDuration: Constants.animationDisplaySideButtonsDuration, animations: {
            self.leftButtonHorizontalConstraint.constant = 0
            self.rightButtonHorizontalConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    public func hideSideButtons() {
        self.leftButton.rotationIcon(duration: Constants.animationDisplaySideButtonsDuration)
        self.rightButton.rotationIcon(duration: Constants.animationDisplaySideButtonsDuration)
        UIView.animate(withDuration: Constants.animationDisplaySideButtonsDuration, animations: {
            self.leftButtonHorizontalConstraint.constant = -Constants.borderButtonWidth
            self.rightButtonHorizontalConstraint.constant = Constants.borderButtonWidth
            self.view.layoutIfNeeded()
        })
    }

    func showCurrentTime(time: String, progress: Float) {
        self.leafView.showCurrentTime(time: time)
        self.tomatoBackground.progress = CGFloat(progress)
    }

    func resetCurrentTime(time: String) {
        self.leafView.resetCurrentTime(time: time)
    }

    func setPomodoroStatusList(pomodoroStatusList: [PomodoroStatus]) {
        self.pomodoroStatusList = pomodoroStatusList
        self.pomodoroTableView.reloadData()
        self.leafView.setPomodoro(pomodoro: pomodoroStatusList[0].pomodoro)
    }

    func displayCreatePomodoroDialog() {
        let alertController = UIAlertController(title: "Pomodoro name?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            let optionalName = alertController.textFields?[0].text
            if let name = optionalName {
                self.presenter.createPomodoro(name: name)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayUpdatePomodoroDialog(pomodoro: Pomodoro) {
        let alertController = UIAlertController(title: "Pomodoro name?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            let optionalName = alertController.textFields?[0].text
            if let name = optionalName {
                self.presenter.updatePomodoro(oldPomodoro: pomodoro, newName: name)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            textField.text = pomodoro.name
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func setStandByMode() {
        self.leafView.setToStandByMode()
        self.startStopBtn.setStartMode()
        self.pomodoroTableView.isHidden = false
        UIView.animate(withDuration: Constants.transitionModeAnimationDuration, animations: {
            self.tomatoBackground.verticalOffset = self.verticalStandByModeOffset
            self.startStopBtnVerticalConstraint.constant = self.verticalStandByModeOffset
            self.tomatoBackground.progress = 0
            self.leavesHeightConstraints.constant = self.leafViewHeightStandByMode
            self.timerListVerticalConstraint.constant = self.verticalTimerListOffset
            self.pomodoroTableView.alpha = 1
            self.leafView.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: Constants.transitionModeAnimationDuration, animations: {
                self.leftButtonHorizontalConstraint.constant = 0
                self.rightButtonHorizontalConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        })
    }

    func setTimerMode() {
        self.leafView.setToTimerMode()
        self.startStopBtn.setStopMode()
        UIView.animate(withDuration: Constants.transitionModeAnimationDuration, animations: {
            self.tomatoBackground.verticalOffset = self.verticalTimerModeOffset
            self.startStopBtnVerticalConstraint.constant = self.verticalTimerModeOffset
            self.leftButtonHorizontalConstraint.constant = -Constants.borderButtonWidth
            self.rightButtonHorizontalConstraint.constant = Constants.borderButtonWidth
            self.leavesHeightConstraints.constant = self.leafViewHeightTimerMode
            self.timerListVerticalConstraint.constant = self.verticalTimerListOffset - Constants.timerTableViewTranslation
            self.pomodoroTableView.alpha = 0
            self.leafView.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.pomodoroTableView.isHidden = true
        })
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

    @IBAction private func onClickTopBarCalendar() {
        self.presenter.onClickTopBarCalendar()
    }

    @IBAction private func onClickTopBarAbout() {
        self.presenter.onClickTopBarAbout()
    }

    @IBAction private func onClickStartStopBtn() {
        self.presenter.onClickStartStopButton()
    }

    @IBAction private func onClickDisplayTimers() {
        self.presenter.onClickDisplayTimers()
    }

    @IBAction private func onClickCreateTimer() {
        self.presenter.onClickCreatePomodoro()
    }

    /*@IBAction private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let verticalTranslation = recognizer.translation(in: self.view).y * 0.7

        if (verticalTranslation <= 0) {
            return
        }

        if verticalTranslation >= Constants.verticalThresholdMode {
            //TODO standByMode
        }

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
        UIView.animate(withDuration: Constants.resetPositionAnimationDuration,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.startStopBtnVerticalConstraint.constant = 0.0
                    self.tomatoBackgroundTopConstraint.constant = 0.0
                    self.leavesHeightConstraints.constant = LeafView.defaultViewHeight
                    self.view.layoutIfNeeded()
                    self.leafView.setNeedsDisplay()
                }, completion: nil)
    }*/

}

extension PomodoroVC: LeafViewListener {
    func onClickEditTimer(pomodoro: Pomodoro) {
        self.presenter.onClickEditPomodoro(pomodoro: pomodoro)
    }
}

extension PomodoroVC: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pomodoroStatusList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear

        cell.textLabel?.font = .boldSystemFont(ofSize: Constants.timerCellFontSize)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.white
        let pomodoroStatus = self.pomodoroStatusList[indexPath.row]
        cell.textLabel?.text = pomodoroStatus.pomodoro.name
        if pomodoroStatus.isSelected {
            cell.imageView?.image = Constants.selectedCheck
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }

}

extension PomodoroVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPomodoro = self.pomodoroStatusList[indexPath.row]
        self.presenter.onClickSelect(pomodoro: selectedPomodoro.pomodoro)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.timerCellHeight
    }
}

