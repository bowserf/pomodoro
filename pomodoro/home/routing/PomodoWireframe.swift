import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let timeInteractor = ManageTimeInteractor(timeManager: TimeManagerImpl())
        let pomodoroVC = PomodoroVC()
        let presenter = PomodoroPresenter(timeInteractor: timeInteractor)
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
