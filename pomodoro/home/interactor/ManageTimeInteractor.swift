import Foundation

class ManageTimeInteractor: ManageTimeInteractorInput {

    private struct Constants {
        static let startTime = 25 * 60
    }

    private let timeManager: TimeManager

    private var listeners: NSHashTable<AnyObject> = NSHashTable(options: .weakMemory)

    private var currentTimer: Int!

    init(timeManager: TimeManager) {
        self.timeManager = timeManager
    }

    func startTimer() {
        self.currentTimer = Constants.startTime
        self.timeManager.startTimer()
    }

    func stopTimer() {
        self.timeManager.stopTimer()
    }

    func getCurrentTime() -> Int {
        return self.currentTimer
    }

    func getState() -> State {
        return self.timeManager.getState()
    }

    func add(listener: ManageTimeInteractorListener) {
        guard !self.listeners.contains(listener) else {
            return
        }

        if (self.listeners.count == 0) {
            self.timeManager.add(listener: self)
        }

        self.listeners.add(listener)
    }

    func remove(listener: ManageTimeInteractorListener) {
        guard self.listeners.contains(listener) else {
            return
        }

        self.listeners.remove(listener)

        if (self.listeners.count == 0) {
            self.timeManager.remove(listener: self)
        }
    }

    private func notifyTimerTimeChanged() {
        for listener in listeners.allObjects {
            (listener as! ManageTimeInteractorListener).onTimerTimeChanged()
        }
    }

    private func notifyTimerTimeEnded() {
        for listener in listeners.allObjects {
            (listener as! ManageTimeInteractorListener).onTimerEnded()
        }
    }

}

extension ManageTimeInteractor: TimeManagerListener {
    func onTimerTimeChanged() {
        self.currentTimer -= 1
        if self.currentTimer == 0 {
            self.timeManager.stopTimer()
            self.notifyTimerTimeEnded()
        } else {
            self.notifyTimerTimeChanged()
        }
    }
}
