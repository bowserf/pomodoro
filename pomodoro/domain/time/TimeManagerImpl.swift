import Foundation

class TimeManagerImpl: TimeManager {

    private struct Constants {
        static let delayBetweenTick = 1
    }

    private var listeners: NSHashTable<AnyObject> = NSHashTable(options: .weakMemory)

    private var state: State
    private var timer: Timer?

    init() {
        self.state = State.StandBy
    }

    func startTimer() {
        self.state = .Running
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(onTimeChanged), userInfo: nil, repeats: true)

    }

    func stopTimer() {
        self.state = .StandBy
        self.timer?.invalidate()
    }

    func getState() -> State {
        return self.state
    }

    func add(listener: TimeManagerListener) {
        if self.listeners.contains(listener) {
            return
        }

        self.listeners.add(listener)

    }

    func remove(listener: TimeManagerListener) {
        guard self.listeners.contains(listener) else {
            return
        }

        self.listeners.remove(listener)
    }

    @IBAction private func onTimeChanged() {
        notifyTimerTimeChanged()
    }

    private func notifyTimerTimeChanged() {
        for listener in listeners.allObjects {
            (listener as! TimeManagerListener).onTimerTimeChanged()
        }
    }

}
