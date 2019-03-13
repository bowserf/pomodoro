class PomodoroPresenter {

    private var view: PomodoroView!

    private let timeInteractor: ManageTimeInteractor
    private let getPomodoroListInteractor: GetPomodoroListInteractorInput
    private let selectPomodoroInteractor: SelectPomodoroInteractorInput

    init(timeInteractor: ManageTimeInteractor,
         getPomodoroListInteractor: GetPomodoroListInteractorInput,
         selectPomodoroInteractor: SelectPomodoroInteractorInput) {
        self.timeInteractor = timeInteractor
        self.getPomodoroListInteractor = getPomodoroListInteractor
        self.selectPomodoroInteractor = selectPomodoroInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.timeInteractor.add(listener: self)

        self.showStandByTime()

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
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
            self.timeInteractor.stopTimer()
            self.view.setStandByMode()
        } else {
            self.showCurrentTime()
            self.timeInteractor.startTimer()
            self.view.setTimerMode()
        }
    }

    func isTimerRunning() -> Bool {
        return self.timeInteractor.getState() == .Running
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

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
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

    func onClickEditPomodoro(pomodoroStatus: PomodoroStatus) {
        self.view.displayUpdatePomodoroDialog(pomodoroStatus: pomodoroStatus)
    }

    func updatePomodoro(oldPomodoroStatus: PomodoroStatus, newName: String) {
        self.getPomodoroListInteractor.updatePomodoro(oldPomodoro: oldPomodoroStatus.pomodoro, newName: newName)

        if oldPomodoroStatus.isSelected {
            self.selectPomodoroInteractor.setSelectedPomodoro(pomodoro: Pomodoro(name: newName))
        }

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
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

    func pullDownChangeMode() {
        self.view.setStandByMode()
        self.timeInteractor.stopTimer()
    }

    func keepCurrentMode() {
        if self.timeInteractor.getState() == .Running {
            self.view.setTimerMode()
        } else {
            self.view.setStandByMode()
        }
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