import Foundation

class ManageTimeInteractor: ManageTimeInteractorInput {

    #if DEBUG
    public static let startTime = 1 * 60
    #else
    public static let startTime = 25 * 60
    #endif

    private let timeManager: TimeManager

    private var listeners: NSHashTable<AnyObject> = NSHashTable(options: .weakMemory)

    private var currentTimer: Int

    init(timeManager: TimeManager) {
        self.timeManager = timeManager
        self.currentTimer = ManageTimeInteractor.startTime
    }

    func startTimer() {
        self.currentTimer = ManageTimeInteractor.startTime
        self.timeManager.startTimer()
    }

    func stopTimer() {
        self.currentTimer = ManageTimeInteractor.startTime
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
            self.currentTimer = ManageTimeInteractor.startTime
        } else {
            self.notifyTimerTimeChanged()
        }
    }
}
