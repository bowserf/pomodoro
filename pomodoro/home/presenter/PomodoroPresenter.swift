class PomodoroPresenter {

    private var view: PomodoroView!

    private let pomodoroInteractor: ManageTimeInteractor
    private let getPomodoroListInteractor: GetPomodoroListInteractorInput
    private let selectPomodoroInteractor: SelectPomodoroInteractorInput

    init(timeInteractor: ManageTimeInteractor,
         getPomodoroListInteractor: GetPomodoroListInteractorInput,
         selectPomodoroInteractor: SelectPomodoroInteractorInput) {
        self.pomodoroInteractor = timeInteractor
        self.getPomodoroListInteractor = getPomodoroListInteractor
        self.selectPomodoroInteractor = selectPomodoroInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.pomodoroInteractor.add(listener: self)

        self.showStandByTime()

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
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

    func onClickSelect(pomodoro selectedPomodoro: Pomodoro) {
        self.selectPomodoroInteractor.setSelectedPomodoro(pomodoro: selectedPomodoro)

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
    }

    private func createPomodoroStatusList() -> [PomodoroStatus]{
        let selectedPomodoro = self.selectPomodoroInteractor.getSelectedPomodoro()
        let pomodoroList = self.getPomodoroListInteractor.getPomodoroList()
        var pomodoroStatusList = [PomodoroStatus]()
        pomodoroList.forEach{ pomodoro in
            let isSelected = selectedPomodoro.name == pomodoro.name
            pomodoroStatusList.append(PomodoroStatus(pomodoro: pomodoro, isSelected: isSelected))
        }
        return pomodoroStatusList
    }

}

struct PomodoroStatus {

    let pomodoro: Pomodoro
    var isSelected: Bool

}

extension PomodoroPresenter: ManageTimeInteractorListener {
    func onTimerTimeChanged() {
        showCurrentTime()
    }

    func onTimerEnded() {
        print("Timer ended")
    }
}