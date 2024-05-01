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
        case didTapOptionButton
        case didDeleteComment
    }
    
    enum Mutation {
        case setCommentLike(Bool)
        case setCommentContent(String)
        case setIsLogin(Bool)
        case setIsTapWhenNotLogin(Bool)
        case setOptionCommentData(OptionCommentData?)
        case updateComment(Comment)
        case setIsDeleteComment(Bool)
    }
    
    struct State {
        var comment: Comment?
        var communityCommet: CommunityComment?
        var isLiked: Bool
        var content: String = ""
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
        var optionCommentData: OptionCommentData? = nil
        var isDeleteComment: Bool = false
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
            
        case .didTapOptionButton:
            let commnet = currentState.comment!
            let optionCommentData = OptionCommentData(id: commnet.id, content: commnet.content, isWrited: commnet.writed, isCommunity: false)
            
            return .concat([
                .just(.setOptionCommentData(optionCommentData)),
                .just(.setOptionCommentData(nil))
            ])
            
        case .didDeleteComment:
            guard let service = self.perfumeService else { return .just(.setCommentLike(true)) }
            return service.deleteComment(to: currentState.comment!.id)
                .map { _ in .setIsDeleteComment(true)}
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
            
        case .setOptionCommentData(let data):
            state.optionCommentData = data
            
        case .setIsDeleteComment(let isDelete):
            state.isDeleteComment = isDelete
            
        case .updateComment(let comment):
            state.comment = comment
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = perfumeService?.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateComment(let comment):
                return .just(.updateComment(comment))
            default: return .empty()
            }
        } ?? .empty()
        return .merge(mutation, eventMutation)
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
                        return service.updateComment(to: comment)
                            .map { _ in .setCommentLike(true) }
                    }
            } else {
                return CommentAPI.deleteCommentLike(currentState.comment!.id)
                    .catch { _ in .empty() }
                    .flatMap { _ -> Observable<Mutation> in
                        comment.liked = false
                        comment.heartCount -= 1
                        guard let service = self.perfumeService else { return .just(.setCommentLike(false)) }
                        return service.updateComment(to: comment)
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
    
    func reactorForCommentEdit() -> CommentWriteReactor {
        let comment = currentState.comment!
        return CommentWriteReactor(
            perfumeId: comment.perfumeId,
            isWrite: comment.writed,
            content: comment.content,
            commentId: comment.id,
            isCommunity: false,
            commentService: perfumeService)
    }
}

