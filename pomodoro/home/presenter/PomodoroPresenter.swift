class PomodoroPresenter {

    private var view: PomodoroView!

    public func attachView(view: PomodoroView) {
        self.view = view
    }

    public func detachView() {
        self.view = nil
    }

    func isNavigationAndStatusBarDisplayed() -> Bool {
        //TODO
        return true
    }

    func onClickStartStopButton() {

    }

    func onClickTopBarAbout() {
        self.view.showAboutDialog()
    }

    func onClickTopBarCalendar() {

    }
}
