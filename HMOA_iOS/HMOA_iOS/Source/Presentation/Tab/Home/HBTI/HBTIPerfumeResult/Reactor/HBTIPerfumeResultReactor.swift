//
//  HBTIPerfumeResultReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import ReactorKit
import RxSwift

final class HBTIPerfumeResultReactor: Reactor {
    
    enum Action {
        case didTapNextButton
        case didTapPriorityButton(ResultPriority)
    }
    
    enum Mutation {
        case setIsPushNextVC
        case setResultPriority(ResultPriority)
    }
    
    struct State {
        var isPushNextVC: Bool = false
        var resultPriority: ResultPriority = .price
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPushNextVC)
            
        case .didTapPriorityButton(let priority):
            return .just(.setResultPriority(priority))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPushNextVC:
            state.isPushNextVC = true
            
        case .setResultPriority(let priority):
            state.resultPriority = priority
        }
        
        return state
    }
}
