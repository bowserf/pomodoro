import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let timeInteractor = ManageTimeInteractor(timeManager: TimeManagerImpl())
        let pomodoroVC = PomodoroVC()
        let pomodoroStorage = PomodoroStorageDisk()
        let selectPomodoroInteractor = SelectPomodoroInteractor()
        let getPomodoroListInteractor = GetPomodoroListInteractor(selectPomodoroInteractor: selectPomodoroInteractor, pomodoroStorage: pomodoroStorage)
        let presenter = PomodoroPresenter(timeInteractor: timeInteractor, getPomodoroListInteractor: getPomodoroListInteractor, selectPomodoroInteractor: selectPomodoroInteractor)
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
