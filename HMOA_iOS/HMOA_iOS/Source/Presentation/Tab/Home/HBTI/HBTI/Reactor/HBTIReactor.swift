//
//  HBTIReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//
import ReactorKit
import RxSwift

final class HBTIReactor: Reactor {
    
    enum Action {
        case didTapSurveyButton
        case didTapNoteButton
    }
    
    enum Mutation {
        case setIsTapSurveyButton(Bool)
        case setIsTapNoteButton(Bool)
    }
    
    struct State {
        var isTapSurveyButton: Bool = false
        var isTapNoteButton: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapSurveyButton:
            return .concat([
                .just(.setIsTapSurveyButton(true)),
                .just(.setIsTapSurveyButton(false))
            ])
            
        case .didTapNoteButton:
            return .concat([
                .just(.setIsTapNoteButton(true)),
                .just(.setIsTapNoteButton(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsTapSurveyButton(let isTap):
            state.isTapSurveyButton = isTap
            
        case .setIsTapNoteButton(let isTap):
            state.isTapNoteButton = isTap
        }
        
        return state
    }
}
