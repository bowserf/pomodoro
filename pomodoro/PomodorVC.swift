import UIKit

class PomodoroVC: UIViewController {

    private struct Constants {
        static let startStopBtnSize: CGFloat = 100
    }

    private let startStopBtn: TextAndImageAnimatedButton
    private let tomatoBackground: TomatoBackground

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        startStopBtn = TextAndImageAnimatedButton()
        tomatoBackground = TomatoBackground()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tomatoBackground)
        self.view.addSubview(startStopBtn)

        self.view.backgroundColor = UIColor.white

        // startStopBtn constraints
        startStopBtn.translatesAutoresizingMaskIntoConstraints = false
        startStopBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startStopBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startStopBtn.widthAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.heightAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.addTarget(self, action: #selector(onClickStartStopBtn), for: .touchDown)
        
        // tomatoBackground
        tomatoBackground.translatesAutoresizingMaskIntoConstraints = false
        tomatoBackground.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tomatoBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tomatoBackground.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tomatoBackground.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

    @IBAction @objc private func onClickStartStopBtn() {
        startStopBtn.updateState()
    }

}

