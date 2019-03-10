protocol PomodoroView {

    func showAboutDialog()

    func showNavigationAndStatusBar()

    func hideNavigationAndStatusBar()

    func showSideButtons()

    func hideSideButtons()

    func showCurrentTime(time: String, progress: Float)

    func setPomodoroList(pomodoroList: [Pomodoro])

    func displayCreatePomodoroDialog()

    func displayUpdatePomodoroDialog(pomodoro: Pomodoro)

    func setStandByMode()

    func setTimerMode()

    func resetCurrentTime(time: String)
}

