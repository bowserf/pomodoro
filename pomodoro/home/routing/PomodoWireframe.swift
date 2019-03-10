import UIKit


class PomodoWireframe {

    static func createViewController() -> UIViewController {
        let timeInteractor = ManageTimeInteractor(timeManager: TimeManagerImpl())
        let pomodoroVC = PomodoroVC()
        let pomodoroStorage = PomodoroStorageDisk()
        let getPomodoroListInteractor = GetPomodoroListInteractor(pomodoroStorage: pomodoroStorage)
        let selectPomodoroInteractor = SelectPomodoroInteractor(getPomodoroListInteractor: getPomodoroListInteractor)
        let presenter = PomodoroPresenter(timeInteractor: timeInteractor, getPomodoroListInteractor: getPomodoroListInteractor, selectPomodoroInteractor: selectPomodoroInteractor)
        pomodoroVC.presenter = presenter
        return pomodoroVC
    }

}
