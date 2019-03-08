class GetTimerListInteractor: GetTimerListInteractorInput {

    private let timerStorage: TimerStorage

    private var timerList: [String]

    init(timerStorage: TimerStorage) {
        self.timerStorage = timerStorage

        self.timerList = self.timerStorage.loadTimerList()
    }

    func addTimer(name: String) {
        self.timerList.append(name)

        self.timerStorage.saveTimerList(timerList: self.timerList)
    }

    func getTimerList() -> [String] {
        return self.timerList
    }

    func updateTimer(oldName: String, newName: String) {
        let oldIndex = self.timerList.firstIndex(of: oldName)!
        self.timerList[oldIndex] = newName

        self.timerStorage.saveTimerList(timerList: self.timerList)
    }
}
