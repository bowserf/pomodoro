import Foundation

class SelectModeInteractor: SelectModeInteractorInput {

    private var listeners: NSHashTable<AnyObject> = NSHashTable(options: .weakMemory)

    private var mode = PomodoroMode.StandBy

    func changeMode() {
        if self.mode == .StandBy {
            self.mode = .Timer
        } else {
            self.mode = .StandBy
        }
        notifyModeChanged(mode: mode)
    }

    func getMode() -> PomodoroMode {
        return self.mode
    }

    func add(listener: SelectModeInteractorListener) {
        guard !self.listeners.contains(listener) else {
            return
        }

        self.listeners.add(listener)
    }

    func remove(listener: SelectModeInteractorListener) {
        guard self.listeners.contains(listener) else {
            return
        }

        self.listeners.remove(listener)
    }

    private func notifyModeChanged(mode: PomodoroMode) {
        for listener in listeners.allObjects {
            (listener as! SelectModeInteractorListener).onModeChanged(mode: mode)
        }
    }

}
