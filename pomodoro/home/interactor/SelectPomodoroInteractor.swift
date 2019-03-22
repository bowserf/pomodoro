import Foundation

class SelectPomodoroInteractor: SelectPomodoroInteractorInput {

    private var listeners: NSHashTable<AnyObject> = NSHashTable(options: .weakMemory)

    private var selectedPomodoro: Pomodoro!

    func setSelectedPomodoro(pomodoro: Pomodoro) {
        self.selectedPomodoro = pomodoro
        notifySelectedPomodoroChanged(pomodoro: pomodoro)
    }

    func getSelectedPomodoro() -> Pomodoro {
        return self.selectedPomodoro
    }

    func add(listener: SelectPomodoroInteractorListener) {
        guard !self.listeners.contains(listener) else {
            return
        }

        self.listeners.add(listener)
    }

    func remove(listener: SelectPomodoroInteractorListener) {
        guard self.listeners.contains(listener) else {
            return
        }

        self.listeners.remove(listener)
    }

    private func notifySelectedPomodoroChanged(pomodoro: Pomodoro) {
        for listener in listeners.allObjects {
            (listener as! SelectPomodoroInteractorListener).onSelectedPomodoroChanged(pomodoro: pomodoro)
        }
    }

}
