class PomodoroPresenter {

    private var view: PomodoroView!

    private let timeInteractor: ManageTimeInteractor
    private let getTimerListInteractor: GetTimerListInteractorInput

    init(timeInteractor: ManageTimeInteractor,
         getTimerListInteractor: GetTimerListInteractorInput) {
        self.timeInteractor = timeInteractor
        self.getTimerListInteractor = getTimerListInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.timeInteractor.add(listener: self)

        self.showStandByTime()
        self.view.setTimerList(timerList: self.getTimerListInteractor.getTimerList())
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
            self.showStandByTime()
            self.view.showNavigationAndStatusBar()
            self.timeInteractor.stopTimer()
            self.view.setStandByMode()
        } else {
            self.view.hideNavigationAndStatusBar()
            self.showCurrentTime()
            self.timeInteractor.startTimer()
            self.view.setTimerMode()
        }
    }

    func onClickTopBarAbout() {
        self.view.showAboutDialog()
    }

    func onClickTopBarCalendar() {

    }

    func onClickDisplayTimers() {

    }

    func onClickCreateTimer() {
        self.view.displayCreateTimerDialog()
    }

    func createTimer(name: String) {
        self.getTimerListInteractor.addTimer(name: name)
    }

    private func showStandByTime() {
        let currentTime = self.timeInteractor.getCurrentTime()
        let minutes = currentTime / 60
        self.view.resetCurrentTime(time: String(minutes))
    }

    private func showCurrentTime() {
        let currentTime = self.timeInteractor.getCurrentTime()
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        let time = String.localizedStringWithFormat("%02d:%02d", minutes, seconds)
        let progress = 1 - Float(currentTime) / Float(ManageTimeInteractor.startTime)
        self.view.showCurrentTime(time: time, progress: progress)
    }

    func onClickEditTimer(timer: String) {
        self.view.displayUpdateTimerDialog(timer: timer)
    }
}

extension PomodoroPresenter: ManageTimeInteractorListener {
    func onTimerTimeChanged() {
        showCurrentTime()
    }

    func onTimerEnded() {
        print("Timer ended")
    }
}