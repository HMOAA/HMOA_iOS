//
//  HBTIReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//
import ReactorKit
import RxSwift

class HBTIReactor: Reactor {
    
    enum Action {
        case didTapSurveyButton
    }
    
    enum Mutation {
        case setIsTapSurveyButton(Bool)
    }
    
    struct State {
        var isTapSurveyButton: Bool = false
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsTapSurveyButton(let isTap):
            state.isTapSurveyButton = isTap
        }
        
        return state
    }
}
