//
//  QnADetailReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import Foundation

import ReactorKit
import RxSwift

class QnADetailReactor: Reactor {
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
        case viewDidLoad
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
    }
    
    init(_ id: Int, _ service: CommunityListProtocol?) {
        initialState = State(communityId: id)
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setUpPostSection(),
                setUpCommentSection()
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
            state.commentItem = [comment]
            
            if state.commentCount == 0 {
                state.communityItems.commentItem = [comment]
            } else {
                state.communityItems.commentItem.append(comment)
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
            state.communityItems.postItem = [detail]
            
        case .setPhotoItem(let item):
            state.photoItem = item
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
    

extension QnADetailReactor {
    func setUpPostSection() -> Observable<Mutation> {
        return CommunityAPI.fetchCommunityDetail(currentState.communityId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                print(data)
                return .concat([
                    .just(.setCategory(data.category)),
                    .just(.setPostItem([data])),
                    .just(.setPhotoItem(data.communityPhotos)),
                    .just(.setContent(data.content))
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
                
                commentItem.append(contentsOf: data.comments)

                
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
                return .concat([
                    .just(.setComment(data)),
                    .just(.setIsEndEditing(true)),
                    .just(.setIsEndEditing(false))
                ])
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
    
    func reactorForPostEdit() -> CommunityWriteReactor {
        
        return CommunityWriteReactor(
            communityId: currentState.communityId,
            content: currentState.content,
            title: currentState.postItem[0].title,
            category: currentState.category,
            service: service!)
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
