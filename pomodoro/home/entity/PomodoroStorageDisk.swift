import Foundation

class PomodoroStorageDisk: PomodoroStorage {

    private struct Constants {
        static let timerListArchiveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let timerListArchiveFileUrl = timerListArchiveDirectory.appendingPathComponent("timer_list").path
    }

    func savePomodoroList(pomodoroList: [Pomodoro]) {
        NSKeyedArchiver.archiveRootObject(pomodoroList, toFile: Constants.timerListArchiveFileUrl)
    }

    func loadPomodoroList() -> [Pomodoro] {
        let optionalPomodoroList = NSKeyedUnarchiver.unarchiveObject(withFile: Constants.timerListArchiveFileUrl) as? [Pomodoro]

        guard let pomodoroList = optionalPomodoroList else {
            return [Pomodoro]()
        }

        return pomodoroList
    }

}
