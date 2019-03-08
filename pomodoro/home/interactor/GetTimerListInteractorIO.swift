protocol GetTimerListInteractorInput {

    func addTimer(name: String)

    func getTimerList() -> [String]

    func updateTimer(oldName: String, newName: String)

}
