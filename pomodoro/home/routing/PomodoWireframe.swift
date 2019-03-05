import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let pomodoroVC = PomodoroVC()
        let presenter = PomodoroPresenter()
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
