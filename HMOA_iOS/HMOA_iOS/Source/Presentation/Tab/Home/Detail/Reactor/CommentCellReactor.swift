//
//  CommentCellReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import ReactorKit
import RxSwift

class CommentCellReactor: Reactor {
    var initialState: State
    
    enum Action {
        case didTapLikeButton
    }
    
    enum Mutation {
         case setCommentLike(Bool)
    }
    
    struct State {
        var likeCount: Int = 0
        var isLike: Bool = false
    }
    
    init(comment: Comment) {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLikeButton:
            // TODO: 서버 통신
            if Int.random(in: 0...10).isMultiple(of: 2) {
                return .just(.setCommentLike(true))
            } else {
                return .just(.setCommentLike(false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentLike(let isLike):
            state.isLike = isLike
            state.likeCount += isLike ? 1 : -1
        }
        
        return state
    }
}
