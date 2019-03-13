import Foundation

class GetPomodoroListInteractor: GetPomodoroListInteractorInput {

    private struct Constants {
        static let defaultTimer = Pomodoro(id: "default", name: "Default")
    }

    private let pomodoroStorage: PomodoroStorage

    private var pomodoroList: [Pomodoro]

    init(pomodoroStorage: PomodoroStorage) {
        self.pomodoroStorage = pomodoroStorage

        self.pomodoroList = self.pomodoroStorage.loadPomodoroList()
        
        if self.pomodoroList.isEmpty {
            self.pomodoroList.append(Constants.defaultTimer)
        }
    }

    func addPomodoro(name: String) {
        let id = NSUUID().uuidString
        let pomodoro = Pomodoro(id: id, name: name)
        self.pomodoroList.append(pomodoro)

        self.pomodoroStorage.savePomodoroList(pomodoroList: self.pomodoroList)
    }

    func getPomodoroList() -> [Pomodoro] {
        return self.pomodoroList
    }

    func updatePomodoro(oldPomodoro: Pomodoro, newName: String) {
        let oldIndex = self.pomodoroList.firstIndex(where: { $0.id == oldPomodoro.id })!
        self.pomodoroList[oldIndex] = Pomodoro(id: oldPomodoro.id, name: newName)

        self.pomodoroStorage.savePomodoroList(pomodoroList: self.pomodoroList)
    }
}
