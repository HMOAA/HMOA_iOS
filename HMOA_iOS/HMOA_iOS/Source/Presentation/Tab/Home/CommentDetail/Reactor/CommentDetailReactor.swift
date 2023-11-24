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
        case viewDidLoad(Bool)
    }
    
    enum Mutation {
        case setCommentLike(Bool)
        case setCommentContent(String)
        case setIsLogin(Bool)
        case setIsTapWhenNotLogin(Bool)
    }
    
    struct State {
        var comment: Comment
        var isLiked: Bool = false
        var content: String
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
    }
    
    init(_ comment: Comment) {
        initialState = State(comment: comment, isLiked: comment.liked, content: comment.content)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLikeButton:
            if currentState.isLogin {
                return setCommentLike()
            } else {
                return .concat([
                    .just(.setIsTapWhenNotLogin(true)),
                    .just(.setIsTapWhenNotLogin(false))
                ])
            }
            
        case .viewDidLoad(let isLogin):
            return .just(.setIsLogin(isLogin))
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
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setIsTapWhenNotLogin(let isTap):
            state.isTapWhenNotLogin = isTap
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
