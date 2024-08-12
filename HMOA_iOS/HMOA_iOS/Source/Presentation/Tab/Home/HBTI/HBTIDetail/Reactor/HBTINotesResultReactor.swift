//
//  HBTINotesResultReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/6/24.
//

import ReactorKit
import RxSwift

class HBTINotesResultReactor: Reactor {
    enum Action {
        case nextButtonTapped
    }
    
    enum Mutation {
        case setShouldProceedToNextStep(Bool)
    }
    
    struct State {
        var selectedNotes: [NoteItem]
        var shouldProceedToNextStep: Bool = false
    }
    
    let initialState: State
    
    init(selectedNotes: [NoteItem]) {
        initialState = State(selectedNotes: selectedNotes)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextButtonTapped:
            return .just(.setShouldProceedToNextStep(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setShouldProceedToNextStep(let shouldProceed):
            newState.shouldProceedToNextStep = shouldProceed
        }
        return newState
    }
}
