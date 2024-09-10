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
        case didTapPriceButton(String)
    }
    
    enum Mutation {
        case setSelectedPrice(String)
        case setIsEnabledNextButton
    }
    
    struct State {
        var selectedPrice: String? = nil
        var isEnabledNextButton: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapPriceButton(let price):
            return .concat([
                .just(.setSelectedPrice(price)),
                .just(.setIsEnabledNextButton)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPrice(let price):
            state.selectedPrice = state.selectedPrice == price ? nil : price
            
        case .setIsEnabledNextButton:
            state.isEnabledNextButton = state.selectedPrice != nil
        }
        
        return state
    }
}
