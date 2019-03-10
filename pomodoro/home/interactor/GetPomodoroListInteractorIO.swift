protocol GetPomodoroListInteractorInput {

    func addPomodoro(name: String)

    func getPomodoroList() -> [Pomodoro]

    func updatePomodoro(oldPomodoro: Pomodoro, newName: String)

}
