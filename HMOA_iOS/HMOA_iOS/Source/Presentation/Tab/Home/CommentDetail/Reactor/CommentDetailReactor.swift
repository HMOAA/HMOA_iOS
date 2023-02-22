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
    var currentCommentId: Int
    
    enum Action {
        case didTapLikeButton
    }
    
    enum Mutation {
        case setCommentLike(Bool)
    }
    
    struct State {
        var comment: Comment
    }
    
    init(_ currentCommentId: Int) {
        self.currentCommentId = currentCommentId
        self.initialState = State(comment: CommentDetailReactor.setCommentDetail(currentCommentId))
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
            state.comment.isLike = isLike
            state.comment.likeCount += isLike ? 1 : -1
        }
        
        return state
    }
}

extension CommentDetailReactor {
    
    static func setCommentDetail(_ id: Int) -> Comment {
        
        print(id)
        
        // TODO: currentCommentId로 서버와 통신
        return Comment(commentId: 1, name: "안녕하세요", image: UIImage(named: "jomalon")!, likeCount: 150, content: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요", isLike: false)
    }
}
