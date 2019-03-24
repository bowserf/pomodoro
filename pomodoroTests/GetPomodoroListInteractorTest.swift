import XCTest
import Cuckoo
@testable import pomodoro

class GetPomodoroListInteractorTest: XCTestCase {

    func testDefaultPomodoro() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)

        // When
        let list = interactor.getPomodoroList()

        // Then
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].id, "default")
        XCTAssertEqual(list[0].name, "Default")
    }

    func testGetPomodoroListAfterPomodoroAdded() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)

        // When
        interactor.addPomodoro(name: "pomodoro-name")
        let list = interactor.getPomodoroList()

        // Then
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list[0].name, "Default")
        XCTAssertEqual(list[1].name, "pomodoro-name")
    }

    func testRemovePomodoro() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)
        interactor.addPomodoro(name: "new-pomodoro")

        let removedPomodoro = interactor.getPomodoroList()[0]
        let lastPomodoro = interactor.getPomodoroList()[1]
        DefaultValueRegistry.register(value: lastPomodoro, forType: Pomodoro.self)

        // When
        interactor.removePomodoro(withId: removedPomodoro.id)
        let list = interactor.getPomodoroList()

        // Then
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].id, lastPomodoro.id)
        XCTAssertEqual(list[0].name, lastPomodoro.name)
    }

    func testRemoveSelectedPomodoroChangeTheSelection() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)
        interactor.addPomodoro(name: "new-pomodoro")

        let removedPomodoro = interactor.getPomodoroList()[0]
        let futureSelectedPomodoro = interactor.getPomodoroList()[1]
        DefaultValueRegistry.register(value: futureSelectedPomodoro, forType: Pomodoro.self)
        stub(mockSelectPomodoroInteractorInput) { stub in
            when(stub.getSelectedPomodoro()).thenReturn(removedPomodoro)
        }

        // When
        interactor.removePomodoro(withId: removedPomodoro.id)

        // Then
        verify(mockSelectPomodoroInteractorInput).setSelectedPomodoro(pomodoro: equal(to: futureSelectedPomodoro))
    }

    func testRestoreSavedPomodoroList() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        stub(mockPomodoroStorage) { stub in
            when(stub.loadPomodoroList()).thenReturn([Pomodoro(id: "pomodoro-id", name: "pomodoro-name")])
        }

        // When
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)
        let list = interactor.getPomodoroList()

        // Then
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].name, "pomodoro-name")
    }

    func testUpdatePomodoro() {
        // Given
        let mockSelectPomodoroInteractorInput = MockSelectPomodoroInteractorInput().withEnabledDefaultImplementation(SelectPomodoroInteractorInputStub())
        let mockPomodoroStorage = MockPomodoroStorage().withEnabledDefaultImplementation(PomodoroStorageStub())
        let interactor = GetPomodoroListInteractor(selectPomodoroInteractor: mockSelectPomodoroInteractorInput, pomodoroStorage: mockPomodoroStorage)
        let defaultPomodoro = interactor.getPomodoroList()[0]

        // When
        interactor.updatePomodoro(oldPomodoro: defaultPomodoro, newName: "new-pomodoro-name")
        let list = interactor.getPomodoroList()

        // Then
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0].name, "new-pomodoro-name")
    }

}
