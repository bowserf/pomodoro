class PomodoroPresenter {

    private var view: PomodoroView!

    private let pomodoroInteractor: ManageTimeInteractor
    private let getPomodoroListInteractor: GetPomodoroListInteractorInput

    init(pomodoroInteractor: ManageTimeInteractor,
         getPomodoroListInteractor: GetPomodoroListInteractorInput) {
        self.pomodoroInteractor = pomodoroInteractor
        self.getPomodoroListInteractor = getPomodoroListInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.pomodoroInteractor.add(listener: self)

        self.showStandByTime()
        self.view.setPomodoroList(pomodoroList: self.getPomodoroListInteractor.getPomodoroList())
    }

    public func detachView() {
        self.view = nil
        self.pomodoroInteractor.remove(listener: self)
    }

    func isNavigationAndStatusBarDisplayed() -> Bool {
        //TODO
        return true
    }

    func onClickStartStopButton() {
        if self.pomodoroInteractor.getState() == .Running {
            self.showStandByTime()
            self.view.showNavigationAndStatusBar()
            self.pomodoroInteractor.stopTimer()
            self.view.setStandByMode()
        } else {
            self.view.hideNavigationAndStatusBar()
            self.showCurrentTime()
            self.pomodoroInteractor.startTimer()
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

    func onClickCreatePomodoro() {
        self.view.displayCreatePomodoroDialog()
    }

    func createPomodoro(name: String) {
        self.getPomodoroListInteractor.addPomodoro(name: name)
    }

    private func showStandByTime() {
        let currentTime = self.pomodoroInteractor.getCurrentTime()
        let minutes = currentTime / 60
        self.view.resetCurrentTime(time: String(minutes))
    }

    private func showCurrentTime() {
        let currentTime = self.pomodoroInteractor.getCurrentTime()
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        let time = String.localizedStringWithFormat("%02d:%02d", minutes, seconds)
        let progress = 1 - Float(currentTime) / Float(ManageTimeInteractor.startTime)
        self.view.showCurrentTime(time: time, progress: progress)
    }

    func onClickEditPomodoro(pomodoro: Pomodoro) {
        self.view.displayUpdatePomodoroDialog(pomodoro: pomodoro)
    }

    func updatePomodoro(oldPomodoro: Pomodoro, newName: String) {
        self.getPomodoroListInteractor.updatePomodoro(oldPomodoro: oldPomodoro, newName: newName)
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