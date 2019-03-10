protocol SelectPomodoroInteractorInput {

    func setSelectedPomodoro(pomodoro: Pomodoro)

    func getSelectedPomodoro() -> Pomodoro

    func add(listener: SelectPomodoroInteractorListener)

    func remove(listener: SelectPomodoroInteractorListener)

}

protocol SelectPomodoroInteractorListener: class {

    func onSelectedPomodoroChanged(pomodoro: Pomodoro)

}
