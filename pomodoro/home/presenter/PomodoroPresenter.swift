class PomodoroPresenter {

    private var view: PomodoroView!

    private let timeInteractor: ManageTimeInteractor
    private let getPomodoroListInteractor: GetPomodoroListInteractorInput
    private let selectPomodoroInteractor: SelectPomodoroInteractorInput
    private let selectModeInteractor: SelectModeInteractorInput

    init(timeInteractor: ManageTimeInteractor,
         getPomodoroListInteractor: GetPomodoroListInteractorInput,
         selectPomodoroInteractor: SelectPomodoroInteractorInput,
         selectModeInteractor: SelectModeInteractorInput) {
        self.timeInteractor = timeInteractor
        self.getPomodoroListInteractor = getPomodoroListInteractor
        self.selectPomodoroInteractor = selectPomodoroInteractor
        self.selectModeInteractor = selectModeInteractor
    }

    public func attachView(view: PomodoroView) {
        self.view = view
        self.timeInteractor.add(listener: self)

        self.showStandByTime()

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)

        scrollToSelectedPomodoro()
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

    func onClickDeleteTimer() {
        if self.getPomodoroListInteractor.getPomodoroList().count == 1 {
            self.view.cantRemoveLastTimer()
            return
        }

        let selectedPomodoro = self.selectPomodoroInteractor.getSelectedPomodoro()
        self.getPomodoroListInteractor.removePomodoro(withId: selectedPomodoro.id)

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)

        scrollToSelectedPomodoro()
    }

    func onClickCreatePomodoro() {
        self.view.displayCreatePomodoroDialog()
    }

    func createPomodoro(name: String) {
        self.getPomodoroListInteractor.addPomodoro(name: name)

        self.selectPomodoroInteractor.setSelectedPomodoro(pomodoro: self.getPomodoroListInteractor.getPomodoroList().last!)

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)

        scrollToSelectedPomodoro()
    }

    func onClickEditPomodoro(pomodoroStatus: PomodoroStatus) {
        self.view.displayUpdatePomodoroDialog(pomodoroStatus: pomodoroStatus)
    }

    func updatePomodoro(oldPomodoroStatus: PomodoroStatus, newName: String) {
        self.getPomodoroListInteractor.updatePomodoro(oldPomodoro: oldPomodoroStatus.pomodoro, newName: newName)

        if oldPomodoroStatus.isSelected {
            self.selectPomodoroInteractor.setSelectedPomodoro(pomodoro: Pomodoro(id: oldPomodoroStatus.pomodoro.id, name: newName))
        }

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)
    }

    func onClickSelect(pomodoro selectedPomodoro: Pomodoro) {
        self.selectPomodoroInteractor.setSelectedPomodoro(pomodoro: selectedPomodoro)

        let pomodoroStatusList = createPomodoroStatusList()
        self.view.setPomodoroStatusList(pomodoroStatusList: pomodoroStatusList)

        scrollToSelectedPomodoro()
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

    func changeMode() {
        self.selectModeInteractor.changeMode()
    }

    func getMode() -> PomodoroMode {
        return self.selectModeInteractor.getMode()
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

    private func createPomodoroStatusList() -> [PomodoroStatus]{
        let selectedPomodoro = self.selectPomodoroInteractor.getSelectedPomodoro()
        let pomodoroList = self.getPomodoroListInteractor.getPomodoroList()
        var pomodoroStatusList = [PomodoroStatus]()
        pomodoroList.forEach{ pomodoro in
            let isSelected = selectedPomodoro.id == pomodoro.id
            pomodoroStatusList.append(PomodoroStatus(pomodoro: pomodoro, isSelected: isSelected))
        }
        return pomodoroStatusList
    }

    private func scrollToSelectedPomodoro() {
        let newSelectedPomodoro = self.selectPomodoroInteractor.getSelectedPomodoro()
        let index = self.getPomodoroListInteractor.getPomodoroList().firstIndex(where: { $0.id == newSelectedPomodoro.id})!
        self.view.scrollTo(position: index)
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
        showCurrentTime()

        self.view.setStandByMode()

        let selectedPomodoro = self.selectPomodoroInteractor.getSelectedPomodoro()
        self.view.showPomodoroEndMessage(pomodoro: selectedPomodoro)
    }
}