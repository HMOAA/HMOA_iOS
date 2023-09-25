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
    let service: UserCommentServiceProtocol
    
    enum Action {
        case didTapLikeButton
        case didTapChangeButton
    }
    
    enum Mutation {
        case setCommentLike(Bool)
        case setIsPresentChangeVC(Bool)
        case setCommentContent(String)
    }
    
    struct State {
        var comment: Comment
        var isTapChangeButton: Bool = false
        var isLiked: Bool = false
        var content: String
    }
    
    init(_ comment: Comment, service: UserCommentServiceProtocol) {
        initialState = State(comment: comment, content: comment.content)
        self.service = service
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
        case .setCommentContent(let comment):
            state.content = comment
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateContent(let content):
                return .just(.setCommentContent(content))
            }
        }
        return .merge(mutation, eventMutation)
    }
    
    func reactorForSetting() -> CommentWriteReactor {
        let comment = currentState.comment
        return CommentWriteReactor(perfumeId: comment.perfumeId,
                                   isWrite: comment.writed,
                                   content: comment.content,
                                   service: service,
                                   commentId: comment.id)
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
