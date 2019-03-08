import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let timeInteractor = ManageTimeInteractor(timeManager: TimeManagerImpl())
        let pomodoroVC = PomodoroVC()
        let timerStorage = TimerStorageDisk()
        let getTimerListInteractor = GetTimerListInteractor(timerStorage: timerStorage)
        let presenter = PomodoroPresenter(timeInteractor: timeInteractor, getTimerListInteractor: getTimerListInteractor)
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
