//
//  HBTINoteReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/15/24.
//
import ReactorKit
import RxSwift

final class HBTIPerfumeSurveyReactor: Reactor {
    
    enum Action {
        case didTapAnswerButton(String)
    }
    
    enum Mutation {
        case setSelectedPrice(String)
    }
    
    struct State {
        var selectedPrice: String? = nil
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAnswerButton(let price):
            return .just(.setSelectedPrice(price))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPrice(let price):
            state.selectedPrice = state.selectedPrice == price ? nil : price
        }
        
        return state
    }
}
