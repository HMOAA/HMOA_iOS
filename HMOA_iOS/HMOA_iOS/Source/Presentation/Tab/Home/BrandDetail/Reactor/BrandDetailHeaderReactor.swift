//
//  BrandDetailHeaderReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import ReactorKit
import RxSwift

class BrandDetailHeaderReactor: Reactor {
    
    enum Action {
        case didTapBrandLikeButton(Bool)
    }
    
    enum Mutation {
        case setBrandLike(Bool)
    }
    
    struct State {
        var isLikeBrand: Bool = false
    }
    
    var initialState: State = State()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBrandLikeButton(let isLike):
            return .just(.setBrandLike(isLike))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setBrandLike(let isLike):
            state.isLikeBrand = isLike
        }
        
        return state
    }
}
