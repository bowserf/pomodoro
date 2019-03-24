protocol SelectModeInteractorInput {

    func changeMode()

    func getMode() -> PomodoroMode

    func add(listener: SelectModeInteractorListener)

    func remove(listener: SelectModeInteractorListener)

}

protocol SelectModeInteractorListener: class {

    func onModeChanged(mode: PomodoroMode)

}

enum PomodoroMode {
    case StandBy
    case Timer
}

