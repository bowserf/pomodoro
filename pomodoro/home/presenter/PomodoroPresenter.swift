class PomodoroPresenter {

    private var view: PomodoroView!

    private let timeInteractor: ManageTimeInteractor

    init(timeInteractor: ManageTimeInteractor) {
        self.timeInteractor = timeInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.timeInteractor.add(listener: self)
    }

    public func detachView() {
        self.view = nil
        self.timeInteractor.remove(listener: self)
    }

    func isNavigationAndStatusBarDisplayed() -> Bool {
        //TODO
        return true
    }

    func onClickStartStopButton() {
        if self.timeInteractor.getState() == .Running {
            self.timeInteractor.stopTimer()
        } else {
            self.timeInteractor.startTimer()
        }
    }

    func onClickTopBarAbout() {
        self.view.showAboutDialog()
    }

    func onClickTopBarCalendar() {

    }
}

extension PomodoroPresenter: ManageTimeInteractorListener {
    func onTimerTimeChanged() {
        print("\(self.timeInteractor.getCurrentTime())")
    }

    func onTimerEnded() {
        print("Timer ended")
    }
}