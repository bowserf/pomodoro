protocol PomodoroView {

    func showAboutDialog()

    func showNavigationAndStatusBar()

    func hideNavigationAndStatusBar()

    func showSideButtons()

    func hideSideButtons()

    func showCurrentTime(time: String, progress: Float)

    func setTimerList(timerList: [String])

    func displayCreateTimerDialog()

    func displayUpdateTimerDialog(timer: String)

    func setStandByMode()

    func setTimerMode()

    func resetCurrentTime(time: String)
}

