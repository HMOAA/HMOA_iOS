//
//  CommunityDetailReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import Foundation

import ReactorKit
import RxSwift

class CommunityDetailReactor: Reactor {
    let initialState: State
    var service: CommunityListProtocol?
    
    enum Action {
        case didChangeTextViewEditing(String)
        case didBeginEditing
        case didTapCommentWriteButton
        case didDeleteComment
        case didTapOptionButton(Int)
        case didDeletePost
        case willDisplayCell(Int)
        case viewDidLoad(Bool)
        case didTapCommentCell(Int)
        case didTapLikeButton
    }
    
    enum Mutation {
        case setPostItem([CommunityDetail])
        case setCommentItem([CommunityComment?])
        case setPhotoItem([CommunityPhoto])
        case setCategory(String)
        case setCommentCount(Int)
        case setContent(String)
        case setIsBegenEditing(Bool)
        case setComment(CommunityComment)
        case setSelectedCommentRow(Int?)
        case setIsEndEditing(Bool)
        case setIsDeleted(Bool)
        case setLoadedPage(Int)
        case editComment(CommunityComment)
        case editCommunityPost(CommunityDetail)
        case setIsLogin(Bool)
        case setSelectedComment(Int?)
        case setPostLike(Bool)
        case setPostLikeCount(Int)
    }
    
    struct State {
        var communityId: Int
        var postItem: [CommunityDetail] = []
        var commentItem: [CommunityComment?] = []
        var photoItem: [CommunityPhoto] = []
        var commentCount: Int? = nil
        var isBeginEditing: Bool = false
        var content: String = ""
        var selectedCommentRow: Int? = nil
        var isEndEditing: Bool = false
        var category: String = ""
        var isDeleted: Bool = false
        var loadedPage: Set<Int> = []
        var communityItems: CommunityDetailItems = CommunityDetailItems(postItem: [], commentItem: [])
        var writeButtonEnable: Bool = false
        var isLogin: Bool = false
        var selectedComment: CommunityComment? = nil
        var isLiked: Bool = false
        var likeCount: Int? = nil
    }
    
    init(_ id: Int, _ service: CommunityListProtocol?) {
        initialState = State(communityId: id)
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad(let isLogin):
            return .concat([
                setUpPostSection(),
                setUpCommentSection(),
                .just(.setIsLogin(isLogin))
            ])
            
        case .didBeginEditing:
            return .concat([
                .just(.setIsBegenEditing(true)),
                .just(.setIsBegenEditing(false))
            ])
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
            
        case .didTapCommentWriteButton:
            if currentState.content != "댓글을 입력하세요" {
                return setPostComment()
            } else { return .empty() }
            
        case .didDeleteComment:
            return deleteCommentInSection()
            
        case .didTapOptionButton(let row):
            return .just(.setSelectedCommentRow(row))
            
        case .didDeletePost:
            return .concat([
                .just(.setIsDeleted(true)),
                .just(.setIsDeleted(false)),
            ])
            
        case .willDisplayCell(let currentPage):
            return setUpCommentSection(currentPage)
            
        case .didTapCommentCell(let row):
            return .concat([
                .just(.setSelectedComment(row)),
                .just(.setSelectedComment(nil))
            ])
            
        case .didTapLikeButton:
            return setPostLike()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentCount(let count):
            if count == 0 {
                state.commentItem = [nil]
                state.communityItems.commentItem = [nil]
            }
            state.commentCount = count
            
        case .setContent(let content):
            state.content = content
            if content.isEmpty {
                state.writeButtonEnable = false }
            else {
                if !state.writeButtonEnable {
                    state.writeButtonEnable = true
                }
            }
            
        case .setIsBegenEditing(let isBegin):
            state.isBeginEditing = isBegin
            
        case .setComment(let comment):
            if state.commentCount == 0 {
                state.commentItem = [comment]
                state.communityItems.commentItem = [comment]
            }
            // 페이징으로 아이템을 받으므로 페이징으로 댓글을 받지 않았을 경우에 append
            else if state.commentItem.count >= state.commentCount! - 1 {
                state.communityItems.commentItem.append(comment)
                state.commentItem.append(comment)
            }
            state.commentCount! += 1
            
        case .setSelectedCommentRow(let row):
            state.selectedCommentRow = row
            
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
            
        case .setCategory(let category):
            state.category = category
            
        case .setIsDeleted(let isDeleted):
            state.isDeleted = isDeleted
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
            
        case .setPostItem(let item):
            state.postItem = item
            state.communityItems.postItem = item
            
        case .setCommentItem(let item):
            state.commentItem = item
            state.communityItems.commentItem = item
            
        case .editComment(let comment):
            if let index = state.commentItem.firstIndex(where: { $0?.commentId == comment.commentId }) {
                state.communityItems.commentItem[index] = comment
            }
            
        case .editCommunityPost(let detail):
            state.postItem = [detail]
            state.photoItem = detail.communityPhotos
            state.content = detail.content
            state.communityItems.postItem = [detail]
            
        case .setPhotoItem(let item):
            state.photoItem = item
            
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
            
        case .setSelectedComment(let row):
            guard let row = row else { return state }
            state.selectedComment = state.commentItem[row]
            
        case .setPostLike(let isLiked):
            state.isLiked = isLiked
            
        case .setPostLikeCount(let count):
            state.likeCount = count
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service?.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .editCommunityComment(let comment):
                return .just(.editComment(comment))
            case .editCommunityDetail(let detail):
                return .just(.editCommunityPost(detail))
            default: return .empty()
            }
        } ?? .empty()
        return .merge(mutation, eventMutation)
    }
}
    

extension CommunityDetailReactor {
    
    func setUpPostSection() -> Observable<Mutation> {
        return CommunityAPI.fetchCommunityDetail(currentState.communityId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    .just(.setCategory(data.category)),
                    .just(.setPostItem([data])),
                    .just(.setPhotoItem(data.communityPhotos)),
                    .just(.setContent(data.content)),
                    .just(.setPostLike(data.liked)),
                    .just(.setPostLikeCount(data.heartCount))
                ])
            }
    }
    
    func setUpCommentSection(_ currentPage: Int = 0) -> Observable<Mutation> {
        let currentPage = currentPage
        let query: [String: Int] = ["page": currentPage]
        
        if currentState.loadedPage.contains(currentPage) { return .empty() }
        
        return CommunityAPI.fetchCommunityComment(currentState.communityId, query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var commentItem = self.currentState.commentItem
                
                let newComments = data.comments.filter { newComment in
                    !commentItem.contains(where: { $0?.commentId == newComment.commentId })
                }
                commentItem.append(contentsOf: newComments)

                
                return .concat([
                    .just(.setCommentItem(commentItem)),
                    .just(.setCommentCount(data.commentCount)),
                    .just(.setLoadedPage(currentPage))
                ])
            }
    }
    
    func setPostComment() -> Observable<Mutation> {
        let param = [ "content": currentState.content ]
        return CommunityAPI.postCommunityComment(currentState.communityId, param)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                
                let commentItem = self.currentState.commentItem
                if !commentItem.contains(where: { $0?.commentId == data.commentId }) {
                    return .concat([
                        .just(.setComment(data)),
                        .just(.setIsEndEditing(true)),
                        .just(.setIsEndEditing(false))
                    ])
                } else {
                    return .concat([
                        .just(.setIsEndEditing(true)),
                        .just(.setIsEndEditing(false))
                    ])
                }
            }
    }
    
    func deleteCommentInSection() -> Observable<Mutation> {
        guard let row = currentState.selectedCommentRow else { return .empty() }
        var commentItem = currentState.commentItem
        commentItem.remove(at: row)
        
        return .concat([
            .just(.setCommentItem(commentItem)),
            .just(.setSelectedCommentRow(nil)),
            .just(.setCommentCount(currentState.commentCount! - 1))
        ])
    }
    
    func setPostLike() -> Observable<Mutation> {
        var communityPost = currentState.postItem.first!
        if !currentState.isLiked {
            return CommunityAPI.putCommunityPostLike(id: communityPost.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    communityPost.liked = true
                    communityPost.heartCount = self.currentState.likeCount! + 1
                    guard let service = self.service else { return .just(.setPostLike(true)) }
                    return service.updateCommunityPostLike(to: CategoryList(
                        communityId: communityPost.id,
                        category: communityPost.category,
                        title: communityPost.title,
                        commentCount: self.currentState.commentCount,
                        heartCount: communityPost.heartCount,
                        liked: communityPost.liked))
                    .flatMap { _ -> Observable<Mutation> in
                        return .concat([
                            .just(.setPostLike(true)),
                            .just(.setPostLikeCount(communityPost.heartCount))
                        ])
                    }
                }
        } else {
            return CommunityAPI.deleteCommunityPostLike(id: communityPost.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    communityPost.liked = false
                    communityPost.heartCount = self.currentState.likeCount! - 1
                    guard let service = self.service else { return .just(.setPostLike(false)) }
                    return service.updateCommunityPostLike(to: CategoryList(
                        communityId: communityPost.id,
                        category: communityPost.category,
                        title: communityPost.title,
                        commentCount: self.currentState.commentCount,
                        heartCount: communityPost.heartCount,
                        liked: communityPost.liked))
                    .flatMap { _ -> Observable<Mutation> in
                        return .concat([
                            .just(.setPostLike(false)),
                            .just(.setPostLikeCount(communityPost.heartCount))
                        ])
                    }
                }
        }
    }
    
    func reactorForPostEdit() -> CommunityWriteReactor {

        return CommunityWriteReactor(
            communityId: currentState.communityId,
            content: currentState.content,
            title: currentState.postItem[0].title,
            category: currentState.category,
            photos: currentState.photoItem,
            service: service)
    }
    
    func reactorForCommentEdit() -> CommentWriteReactor {
        return CommentWriteReactor(
            perfumeId: nil,
            isWrite: true,
            content: currentState.commentItem[currentState.selectedCommentRow!]!.content,
            commentId: currentState.commentItem[currentState.selectedCommentRow!]!.commentId,
            isCommunity: true, commentService: nil,
            communityService: service!
        )
    }
}
