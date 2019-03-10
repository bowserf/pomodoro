protocol PomodoroStorage {

    func savePomodoroList(pomodoroList: [Pomodoro])

    func loadPomodoroList() -> [Pomodoro]

}
