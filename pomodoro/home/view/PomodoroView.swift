protocol PomodoroView {

    func showAboutDialog()

    func showNavigationAndStatusBar()

    func hideNavigationAndStatusBar()

    func showSideButtons()

    func hideSideButtons()

    func showCurrentTime(time: String, progress: Float)
}
