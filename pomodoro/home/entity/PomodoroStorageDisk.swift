import Foundation

class PomodoroStorageDisk: PomodoroStorage {

    private struct Constants {
        static let timerListArchiveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let timerListArchiveFileUrl = timerListArchiveDirectory.appendingPathComponent("timer_list").path
    }

    func savePomodoroList(pomodoroList: [Pomodoro]) {
        var list = [String]()
        pomodoroList.forEach { pomodoro in
            list.append(pomodoro.name)
        }
        NSKeyedArchiver.archiveRootObject(list, toFile: Constants.timerListArchiveFileUrl)
    }

    func loadPomodoroList() -> [Pomodoro] {
        let optionalList = NSKeyedUnarchiver.unarchiveObject(withFile: Constants.timerListArchiveFileUrl) as? [String]

        guard let list = optionalList else {
            return [Pomodoro]()
        }

        var pomodoroList = [Pomodoro]()
        list.forEach { element in
            pomodoroList.append(Pomodoro(name: element))
        }

        return pomodoroList
    }

}
