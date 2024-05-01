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
        case updateCommunityComment(CommunityComment)
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
            if let commnet = currentState.comment {
                let optionCommentData = OptionCommentData(id: commnet.id, content: commnet.content, isWrited: commnet.writed, isCommunity: false)
                
                return .concat([
                    .just(.setOptionCommentData(optionCommentData)),
                    .just(.setOptionCommentData(nil))
                ])
            } else {
                let comment = currentState.communityCommet!
                let optionCommentData = OptionCommentData(id: comment.commentId!, content: comment.content, isWrited: comment.writed, isCommunity: true)
                
                return .concat([
                    .just(.setOptionCommentData(optionCommentData)),
                    .just(.setOptionCommentData(nil))
                ])
            }
            
        case .didDeleteComment:
            if let service = self.perfumeService {
                return service.deleteComment(to: currentState.comment!.id)
                    .map { _ in .setIsDeleteComment(true)}
            } else {
                return communityService!.deleteComment(to: (currentState.communityCommet?.commentId)!)
                    .map { _ in .setIsDeleteComment(true)}
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentLike(let isLike):
            state.isLiked = isLike
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
            
        case .updateCommunityComment(let comment):
            state.communityCommet = comment
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let perfumeEventMutation = perfumeService?.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateComment(let comment):
                return .just(.updateComment(comment))
            default: return .empty()
            }
        } ?? .empty()
        
        let communityEventMutation = communityService?.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateCommunityComment(let comment):
                return .just(.updateCommunityComment(comment))
            default: return .empty()
            }
        } ?? .empty()
        return .merge(mutation, perfumeEventMutation, communityEventMutation)
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
        if let comment = currentState.comment {
            return CommentWriteReactor(
                perfumeId: comment.perfumeId,
                isWrite: comment.writed,
                content: comment.content,
                commentId: comment.id,
                isCommunity: false,
                commentService: perfumeService)
        } else {
            let comment = currentState.communityCommet!
            return CommentWriteReactor(
                perfumeId: nil,
                isWrite: comment.writed,
                content: comment.content,
                commentId: comment.commentId,
                isCommunity: true,
                commentService: nil,
                communityService: communityService!
            )
        }
    }
}

