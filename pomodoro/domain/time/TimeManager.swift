protocol TimeManager {

    func startTimer()
    func stopTimer()
    func getState() -> State
    func add(listener: TimeManagerListener)
    func remove(listener: TimeManagerListener)

}

enum State {
    case Running
    case StandBy
}

protocol TimeManagerListener: class {

    func onTimerTimeChanged()

}
