import UIKit

class PomodoroVC: UIViewController {

    private struct Constants {
        static let startStopBtnSize: CGFloat = 100
    }

    private let startStopBtn: TextAndImageAnimatedButton

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        startStopBtn = TextAndImageAnimatedButton()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("You shouldn't use Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(startStopBtn)

        self.view.backgroundColor = UIColor.white

        // startStopBtn constraints
        startStopBtn.translatesAutoresizingMaskIntoConstraints = false
        startStopBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        startStopBtn.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        startStopBtn.widthAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.heightAnchor.constraint(equalToConstant: Constants.startStopBtnSize).isActive = true
        startStopBtn.addTarget(self, action: #selector(onClickStartStopBtn), for: .touchDown)
    }

    @IBAction @objc private func onClickStartStopBtn() {
        startStopBtn.updateState()
    }

}

