protocol ManageTimeInteractorInput {

    func startTimer()

    func stopTimer()

    func getCurrentTime() -> Int

    func getState() -> State

    func add(listener: ManageTimeInteractorListener)

    func remove(listener: ManageTimeInteractorListener)

}

protocol ManageTimeInteractorListener: class {

    func onTimerTimeChanged()

    func onTimerEnded()

}
