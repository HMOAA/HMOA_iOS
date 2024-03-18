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
    let perfumeService: DetailCommentServiceProtocol?
    let communityService: CommunityListProtocol?
    
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
        var comment: Comment?
        var communityCommet: CommunityComment?
        var isLiked: Bool
        var content: String = ""
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
    }
    
    init(comment: Comment?, communityComment: CommunityComment?, perfumeService: DetailCommentServiceProtocol?, communityService: CommunityListProtocol?) {
        
        initialState = State(comment: comment, communityCommet: communityComment, isLiked: comment?.liked ?? false || communityComment?.liked ?? false)
        
        self.perfumeService = perfumeService
        self.communityService = communityService
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
            if var perfumeComment = state.comment {
                let heartCount = perfumeComment.heartCount
                perfumeComment.heartCount = isLike ? heartCount + 1 : heartCount - 1
                state.comment = perfumeComment
            } else {
                var communityCommet = state.communityCommet!
                let heartCount = communityCommet.heartCount
                communityCommet.heartCount = isLike ? heartCount + 1 : heartCount - 1
                state.communityCommet = communityCommet
            }
            
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
        
        if var comment = currentState.comment {
            if !currentState.isLiked {
                return CommentAPI.putCommentLike(comment.id)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        comment.liked = true
                        comment.heartCount += 1
                        guard let service = self.perfumeService else { return .just(.setCommentLike(true)) }
                        return service.setCommentLike(to: comment)
                            .map { _ in .setCommentLike(true) }
                    }
            } else {
                return CommentAPI.deleteCommentLike(currentState.comment!.id)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        comment.liked = false
                        comment.heartCount -= 1
                        guard let service = self.perfumeService else { return .just(.setCommentLike(false)) }
                        return service.setCommentLike(to: comment)
                            .map { _ in .setCommentLike(false) }
                    }
            }
        } else {
            var comment = currentState.communityCommet!
            if !currentState.isLiked {
                return CommunityAPI.putCommunityCommentLike(id: comment.commentId!)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        comment.liked = true
                        comment.heartCount += 1
                        guard let service = self.communityService else { return .just(.setCommentLike(true)) }
                        return service.updateCommunityComment(to: comment)
                            .map { _ in .setCommentLike(true) }
                    }
            } else {
                return CommunityAPI.deleteCommunityCommentLike(id: comment.commentId!)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        comment.liked = false
                        comment.heartCount -= 1
                        guard let service = self.communityService else { return .just(.setCommentLike(false)) }
                        return service.updateCommunityComment(to: comment)
                            .map { _ in .setCommentLike(false) }
                    }
            }
        }
    }
}
