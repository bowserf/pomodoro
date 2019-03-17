protocol GetPomodoroListInteractorInput {

    func addPomodoro(name: String)

    func removePomodoro(withId id: String)

    func getPomodoroList() -> [Pomodoro]

    func updatePomodoro(oldPomodoro: Pomodoro, newName: String)

}
