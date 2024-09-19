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
    }
    
    enum Mutation {
        case setIsPushNextVC
    }
    
    struct State {
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPushNextVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPushNextVC:
            state.isPushNextVC = true
        }
        
        return state
    }
}
