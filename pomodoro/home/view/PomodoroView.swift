protocol PomodoroView {

    func showAboutDialog()

    func showNavigationAndStatusBar()

    func hideNavigationAndStatusBar()

    func showSideButtons()

    func hideSideButtons()

    func showCurrentTime(time: String, progress: Float)

    func setPomodoroStatusList(pomodoroStatusList: [PomodoroStatus])

    func displayCreatePomodoroDialog()

    func displayUpdatePomodoroDialog(pomodoro: Pomodoro)

    func setStandByMode()

    func setTimerMode()

    func resetCurrentTime(time: String)
}

