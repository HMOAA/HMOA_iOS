//
//  CommentDetailReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import ReactorKit
import RxSwift
import UIKit

class CommentDetailReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapLikeButton
        case didTapChangeButton
    }
    
    enum Mutation {
        case setCommentLike(Bool)
        case setIsPresentChangeVC(Bool)
    }
    
    struct State {
        var comment: Comment
        var isTapChangeButton: Bool = false
        var isLiked: Bool = false
    }
    
    init(_ comment: Comment) {
        initialState = State(comment: comment)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLikeButton:
            return setCommentLike()
            
        case .didTapChangeButton:
            return .concat([
                .just(.setIsPresentChangeVC(true)),
                .just(.setIsPresentChangeVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentLike(let isLike):
            state.isLiked = isLike
            let heartCount = state.comment.heartCount
            state.comment.heartCount = isLike ? heartCount + 1 : heartCount - 1
            
        case .setIsPresentChangeVC(let isPresent):
            state.isTapChangeButton = isPresent
        }
        
        return state
    }
}

extension CommentDetailReactor {
    
    func setCommentLike() -> Observable<Mutation> {
        
        if !currentState.isLiked {
            return CommentAPI.putCommentLike(currentState.comment.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setCommentLike(true))
                }
        } else {
            return CommentAPI.deleteCommentLike(currentState.comment.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setCommentLike(false))
                }
        }
    }
}
