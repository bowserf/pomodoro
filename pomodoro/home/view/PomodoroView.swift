protocol PomodoroView {

    func showAboutDialog()

    func showNavigationAndStatusBar()

    func hideNavigationAndStatusBar()

    func showSideButtons()

    func hideSideButtons()

    func showCurrentTime(time: String, progress: Float)

    func setPomodoroStatusList(pomodoroStatusList: [PomodoroStatus])

    func scrollTo(position: Int)

    func displayCreatePomodoroDialog()

    func displayUpdatePomodoroDialog(pomodoroStatus: PomodoroStatus)

    func setStandByMode()

    func setTimerMode()

    func resetCurrentTime(time: String)

    func cantRemoveLastTimer()

    func showPomodoroEndMessage(pomodoro: Pomodoro)
}

