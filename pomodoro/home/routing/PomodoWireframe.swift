import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let timeInteractor = ManageTimeInteractor(timeManager: TimeManagerImpl())
        let pomodoroVC = PomodoroVC()
        let pomodoroStorage = PomodoroStorageDisk()
        let getTimerListInteractor = GetPomodoroListInteractor(pomodoroStorage: pomodoroStorage)
        let presenter = PomodoroPresenter(pomodoroInteractor: timeInteractor, getPomodoroListInteractor: getTimerListInteractor)
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
