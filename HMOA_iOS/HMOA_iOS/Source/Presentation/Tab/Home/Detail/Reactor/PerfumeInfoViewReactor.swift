//
//  PerfumeDetailReactor.swift
//  HMOA_iOSPerfumeInfoViewReactor//
//  Created by 임현규 on 2023/02/21.
//

import ReactorKit

class PerfumeInfoViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didTapPerfumeLikeButton
        case didTapBrandLikeButton
    }
    
    enum Mutation {
        case setPerfumeLike(Bool)
        case setBrandLike(Bool)
    }
    
    struct State {
        var likeCount: Int = 0
        var isLikePerfume: Bool = false
        var isLikeBrand: Bool = false
    }
    
    init(detail: FirstDetail) {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBrandLikeButton:
            // TODO: 서버 통신
            if Int.random(in: 0...10).isMultiple(of: 2) {
                return .just(.setBrandLike(true))
            } else {
                return .just(.setBrandLike(false))
            }
            
        case .didTapPerfumeLikeButton:
            
            // TODO: 서버 통신
            // 임의로 랜덤하게 보내봄
            if Int.random(in: 0...10).isMultiple(of: 2) {
                return .just(.setPerfumeLike(true))
            } else {
                return .just(.setPerfumeLike(false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPerfumeLike(let isLike):
            state.isLikePerfume = isLike
            state.likeCount += isLike ? 1 : -1
        case .setBrandLike(let isLike):
            state.isLikeBrand = isLike
        }
        
        return state
    }
}
