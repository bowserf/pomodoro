protocol TimerStorage {

    func saveTimerList(timerList: [String])

    func loadTimerList() -> [String]

}
