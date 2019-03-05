import UIKit

class AppWireframe {

    func installRootVC(application: UIApplication) {
        let pomodoroVC = PomodoWireframe.createViewController()
        let rootVC = TransparentNavigationController(rootViewController: pomodoroVC)
        application.keyWindow?.rootViewController = rootVC
    }

}
