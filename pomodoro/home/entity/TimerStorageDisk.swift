import Foundation

class TimerStorageDisk: TimerStorage {

    private struct Constants {
        static let timerListArchiveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        static let timerListArchiveFileUrl = timerListArchiveDirectory.appendingPathComponent("timer_list").path
    }

    func saveTimerList(timerList: [String]) {
        NSKeyedArchiver.archiveRootObject(timerList, toFile: Constants.timerListArchiveFileUrl)
    }

    func loadTimerList() -> [String] {
        let optionalTimerList = NSKeyedUnarchiver.unarchiveObject(withFile: Constants.timerListArchiveFileUrl) as? [String]

        guard let timerList = optionalTimerList else {
            return [String]()
        }
        return timerList
    }

}
