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
    }
    
    enum Mutation {
        case setCommentLike(Bool)
        case setCommentContent(String)
    }
    
    struct State {
        var comment: Comment
        var isLiked: Bool = false
        var content: String
    }
    
    init(_ comment: Comment) {
        initialState = State(comment: comment, isLiked: comment.liked, content: comment.content)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLikeButton:
            return setCommentLike()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentLike(let isLike):
            state.isLiked = isLike
            let heartCount = state.comment.heartCount
            state.comment.heartCount = isLike ? heartCount + 1 : heartCount - 1
            
        case .setCommentContent(let comment):
            state.content = comment
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
