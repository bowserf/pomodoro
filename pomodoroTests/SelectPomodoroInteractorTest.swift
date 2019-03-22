import XCTest
@testable import pomodoro

class SelectPomodoroInteractorTest: XCTestCase {

    func testSetSelectedPomodoro() {
        // Given
        let interactor = SelectPomodoroInteractor()

        // When
        interactor.setSelectedPomodoro(pomodoro: Pomodoro(id: "pomodoro-id", name: "pomodoro-name"))
        let selectedPomodoro = interactor.getSelectedPomodoro()

        // Then
        XCTAssertEqual(selectedPomodoro.id, "pomodoro-id")
        XCTAssertEqual(selectedPomodoro.name, "pomodoro-name")
    }

    func testBeNotifiedOfSelectedPomodoroChanged() {
        // Given
        let interactor = SelectPomodoroInteractor()

        class Listener: SelectPomodoroInteractorListener {
            func onSelectedPomodoroChanged(pomodoro: Pomodoro) {
                // Then
                XCTAssertEqual(pomodoro.id, "pomodoro-id")
                XCTAssertEqual(pomodoro.name, "pomodoro-name")
            }
        }
        let listener = Listener()
        interactor.add(listener: listener)

        // When
        interactor.setSelectedPomodoro(pomodoro: Pomodoro(id: "pomodoro-id", name: "pomodoro-name"))
    }

}
