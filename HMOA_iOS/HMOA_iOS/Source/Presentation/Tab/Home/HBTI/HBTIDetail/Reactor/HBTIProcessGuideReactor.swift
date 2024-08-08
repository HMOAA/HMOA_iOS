//
//  HBTIDetailReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/29/24.
//

import RxSwift
import ReactorKit

class HBTIProcessGuideReactor: Reactor {
    enum Action {
        case nextButtonTapped
    }
    
    enum Mutation {
        case setShowQuantitySelection(Bool)
    }
    
    struct State {
        var showQuantitySelection: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextButtonTapped:
            return .just(.setShowQuantitySelection(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setShowQuantitySelection(let show):
            newState.showQuantitySelection = show
        }
        return newState
    }
}
