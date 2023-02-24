//
//  SearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import ReactorKit
import RxSwift

class SearchReactor: Reactor {
    
    enum Action {
        case didTapBackButton
    }
    
    enum Mutation {
        case isPopVC(Bool)
    }
    
    struct State {
        var Content: String = ""
        var isPopVC: Bool = false
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.isPopVC(true)),
                .just(.isPopVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isPopVC(let isPop):
            state.isPopVC = isPop
        }
        
        return state
    }
}
