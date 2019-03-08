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
        let currentTime = self.timeInteractor.getCurrentTime()
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        let time = String.localizedStringWithFormat("%02d:%02d", minutes, seconds)
        let progress = 1 - Float(currentTime) / Float(ManageTimeInteractor.startTime)
        self.view.showCurrentTime(time: time, progress: progress)
    }

    func onTimerEnded() {
        print("Timer ended")
    }
}