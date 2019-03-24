// MARK: - Mocks generated from file: ../../pomodoro/home/entity/PomodoroStorage.swift at 2019-03-22 22:47:36 +0000


import Cuckoo
@testable import pomodoro


 class MockPomodoroStorage: PomodoroStorage, Cuckoo.ProtocolMock {
     typealias MocksType = PomodoroStorage
     typealias Stubbing = __StubbingProxy_PomodoroStorage
     typealias Verification = __VerificationProxy_PomodoroStorage

    private var __defaultImplStub: PomodoroStorage?

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

     func enableDefaultImplementation(_ stub: PomodoroStorage) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    
    
     func savePomodoroList(pomodoroList: [Pomodoro])  {
        
            return cuckoo_manager.call("savePomodoroList(pomodoroList: [Pomodoro])",
                parameters: (pomodoroList),
                escapingParameters: (pomodoroList),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.savePomodoroList(pomodoroList: pomodoroList))
        
    }
    
    
    
     func loadPomodoroList()  -> [Pomodoro] {
        
            return cuckoo_manager.call("loadPomodoroList() -> [Pomodoro]",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.loadPomodoroList())
        
    }
    

	 struct __StubbingProxy_PomodoroStorage: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func savePomodoroList<M1: Cuckoo.Matchable>(pomodoroList: M1) -> Cuckoo.ProtocolStubNoReturnFunction<([Pomodoro])> where M1.MatchedType == [Pomodoro] {
	        let matchers: [Cuckoo.ParameterMatcher<([Pomodoro])>] = [wrap(matchable: pomodoroList) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPomodoroStorage.self, method: "savePomodoroList(pomodoroList: [Pomodoro])", parameterMatchers: matchers))
	    }
	    
	    func loadPomodoroList() -> Cuckoo.ProtocolStubFunction<(), [Pomodoro]> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPomodoroStorage.self, method: "loadPomodoroList() -> [Pomodoro]", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PomodoroStorage: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func savePomodoroList<M1: Cuckoo.Matchable>(pomodoroList: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == [Pomodoro] {
	        let matchers: [Cuckoo.ParameterMatcher<([Pomodoro])>] = [wrap(matchable: pomodoroList) { $0 }]
	        return cuckoo_manager.verify("savePomodoroList(pomodoroList: [Pomodoro])", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func loadPomodoroList() -> Cuckoo.__DoNotUse<[Pomodoro]> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("loadPomodoroList() -> [Pomodoro]", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class PomodoroStorageStub: PomodoroStorage {
    

    

    
     func savePomodoroList(pomodoroList: [Pomodoro])  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func loadPomodoroList()  -> [Pomodoro] {
        return DefaultValueRegistry.defaultValue(for: [Pomodoro].self)
    }
    
}


// MARK: - Mocks generated from file: ../../pomodoro/home/interactor/SelectPomodoroInteractorIO.swift at 2019-03-22 22:47:36 +0000


import Cuckoo
@testable import pomodoro


 class MockSelectPomodoroInteractorInput: SelectPomodoroInteractorInput, Cuckoo.ProtocolMock {
     typealias MocksType = SelectPomodoroInteractorInput
     typealias Stubbing = __StubbingProxy_SelectPomodoroInteractorInput
     typealias Verification = __VerificationProxy_SelectPomodoroInteractorInput

    private var __defaultImplStub: SelectPomodoroInteractorInput?

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

     func enableDefaultImplementation(_ stub: SelectPomodoroInteractorInput) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    
    
     func setSelectedPomodoro(pomodoro: Pomodoro)  {
        
            return cuckoo_manager.call("setSelectedPomodoro(pomodoro: Pomodoro)",
                parameters: (pomodoro),
                escapingParameters: (pomodoro),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.setSelectedPomodoro(pomodoro: pomodoro))
        
    }
    
    
    
     func getSelectedPomodoro()  -> Pomodoro {
        
            return cuckoo_manager.call("getSelectedPomodoro() -> Pomodoro",
                parameters: (),
                escapingParameters: (),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.getSelectedPomodoro())
        
    }
    
    
    
     func add(listener: SelectPomodoroInteractorListener)  {
        
            return cuckoo_manager.call("add(listener: SelectPomodoroInteractorListener)",
                parameters: (listener),
                escapingParameters: (listener),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.add(listener: listener))
        
    }
    
    
    
     func remove(listener: SelectPomodoroInteractorListener)  {
        
            return cuckoo_manager.call("remove(listener: SelectPomodoroInteractorListener)",
                parameters: (listener),
                escapingParameters: (listener),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.remove(listener: listener))
        
    }
    

	 struct __StubbingProxy_SelectPomodoroInteractorInput: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func setSelectedPomodoro<M1: Cuckoo.Matchable>(pomodoro: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Pomodoro)> where M1.MatchedType == Pomodoro {
	        let matchers: [Cuckoo.ParameterMatcher<(Pomodoro)>] = [wrap(matchable: pomodoro) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSelectPomodoroInteractorInput.self, method: "setSelectedPomodoro(pomodoro: Pomodoro)", parameterMatchers: matchers))
	    }
	    
	    func getSelectedPomodoro() -> Cuckoo.ProtocolStubFunction<(), Pomodoro> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockSelectPomodoroInteractorInput.self, method: "getSelectedPomodoro() -> Pomodoro", parameterMatchers: matchers))
	    }
	    
	    func add<M1: Cuckoo.Matchable>(listener: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SelectPomodoroInteractorListener)> where M1.MatchedType == SelectPomodoroInteractorListener {
	        let matchers: [Cuckoo.ParameterMatcher<(SelectPomodoroInteractorListener)>] = [wrap(matchable: listener) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSelectPomodoroInteractorInput.self, method: "add(listener: SelectPomodoroInteractorListener)", parameterMatchers: matchers))
	    }
	    
	    func remove<M1: Cuckoo.Matchable>(listener: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(SelectPomodoroInteractorListener)> where M1.MatchedType == SelectPomodoroInteractorListener {
	        let matchers: [Cuckoo.ParameterMatcher<(SelectPomodoroInteractorListener)>] = [wrap(matchable: listener) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSelectPomodoroInteractorInput.self, method: "remove(listener: SelectPomodoroInteractorListener)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_SelectPomodoroInteractorInput: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func setSelectedPomodoro<M1: Cuckoo.Matchable>(pomodoro: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Pomodoro {
	        let matchers: [Cuckoo.ParameterMatcher<(Pomodoro)>] = [wrap(matchable: pomodoro) { $0 }]
	        return cuckoo_manager.verify("setSelectedPomodoro(pomodoro: Pomodoro)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getSelectedPomodoro() -> Cuckoo.__DoNotUse<Pomodoro> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getSelectedPomodoro() -> Pomodoro", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func add<M1: Cuckoo.Matchable>(listener: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == SelectPomodoroInteractorListener {
	        let matchers: [Cuckoo.ParameterMatcher<(SelectPomodoroInteractorListener)>] = [wrap(matchable: listener) { $0 }]
	        return cuckoo_manager.verify("add(listener: SelectPomodoroInteractorListener)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func remove<M1: Cuckoo.Matchable>(listener: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == SelectPomodoroInteractorListener {
	        let matchers: [Cuckoo.ParameterMatcher<(SelectPomodoroInteractorListener)>] = [wrap(matchable: listener) { $0 }]
	        return cuckoo_manager.verify("remove(listener: SelectPomodoroInteractorListener)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SelectPomodoroInteractorInputStub: SelectPomodoroInteractorInput {
    

    

    
     func setSelectedPomodoro(pomodoro: Pomodoro)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func getSelectedPomodoro()  -> Pomodoro {
        return DefaultValueRegistry.defaultValue(for: Pomodoro.self)
    }
    
     func add(listener: SelectPomodoroInteractorListener)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
     func remove(listener: SelectPomodoroInteractorListener)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



 class MockSelectPomodoroInteractorListener: SelectPomodoroInteractorListener, Cuckoo.ProtocolMock {
     typealias MocksType = SelectPomodoroInteractorListener
     typealias Stubbing = __StubbingProxy_SelectPomodoroInteractorListener
     typealias Verification = __VerificationProxy_SelectPomodoroInteractorListener

    private var __defaultImplStub: SelectPomodoroInteractorListener?

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

     func enableDefaultImplementation(_ stub: SelectPomodoroInteractorListener) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    

    

    
    
    
     func onSelectedPomodoroChanged(pomodoro: Pomodoro)  {
        
            return cuckoo_manager.call("onSelectedPomodoroChanged(pomodoro: Pomodoro)",
                parameters: (pomodoro),
                escapingParameters: (pomodoro),
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.onSelectedPomodoroChanged(pomodoro: pomodoro))
        
    }
    

	 struct __StubbingProxy_SelectPomodoroInteractorListener: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func onSelectedPomodoroChanged<M1: Cuckoo.Matchable>(pomodoro: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(Pomodoro)> where M1.MatchedType == Pomodoro {
	        let matchers: [Cuckoo.ParameterMatcher<(Pomodoro)>] = [wrap(matchable: pomodoro) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockSelectPomodoroInteractorListener.self, method: "onSelectedPomodoroChanged(pomodoro: Pomodoro)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_SelectPomodoroInteractorListener: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func onSelectedPomodoroChanged<M1: Cuckoo.Matchable>(pomodoro: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Pomodoro {
	        let matchers: [Cuckoo.ParameterMatcher<(Pomodoro)>] = [wrap(matchable: pomodoro) { $0 }]
	        return cuckoo_manager.verify("onSelectedPomodoroChanged(pomodoro: Pomodoro)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}

}

 class SelectPomodoroInteractorListenerStub: SelectPomodoroInteractorListener {
    

    

    
     func onSelectedPomodoroChanged(pomodoro: Pomodoro)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}

