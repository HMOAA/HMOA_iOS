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
    
    enum Action {
        case viewWillAppear
        case didChangeTextViewEditing(String)
        case didBeginEditing
        case didTapCommentWriteButton
        case didDeleteComment
        case didTapOptionButton(Int)
        case didDeletePost
        case willDisplayCell(Int)
    }
    
    enum Mutation {
        case setPostItem([CommunityDetail])
        case setCommentItem([CommunityComment])
        case setCategory(String)
        case setCommentCount(Int)
        case setContent(String)
        case setIsBegenEditing(Bool)
        case setComment(CommunityComment)
        case setSelectedCommentRow(Int?)
        case setIsEndEditing(Bool)
        case setIsDeleted(Bool)
        case setCurrentPage(Int)
        case setLoadedPage(Int)
    }
    
    struct State {
        var communityId: Int
        var postItem: [CommunityDetail] = []
        var commentItem: [CommunityComment] = []
        var commentCount: Int? = nil
        var isBeginEditing: Bool = false
        var content: String = ""
        var selectedCommentRow: Int? = nil
        var isEndEditing: Bool = false
        var category: String = ""
        var isDeleted: Bool = false
        var currentPage: Int = 0
        var loadedPage: Set<Int> = []
        var communityItems: CommunityDetailItems = CommunityDetailItems(postItem: [], commentItem: [])
    }
    
    init(_ id: Int) {
        initialState = State(communityId: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                setUpPostSection(),
                setUpCommentSection()
            ])
            
        case .didBeginEditing:
            return .just(.setIsBegenEditing(true))
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
            
        case .didTapCommentWriteButton:
            if !currentState.content.isEmpty || currentState.content != "댓글을 입력하세요" {
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
            return .concat([
                .just(.setCurrentPage(currentPage)),
                setUpCommentSection(currentPage)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCommentCount(let count):
            state.commentCount = count
            
        case .setContent(let content):
            state.content = content
            
        case .setIsBegenEditing(let isBegin):
            state.isBeginEditing = isBegin
            
        case .setComment(let comment):
            state.communityItems.commentItem.append(comment)
            state.commentCount! += 1
            
        case .setSelectedCommentRow(let row):
            state.selectedCommentRow = row
            
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
            
        case .setCategory(let category):
            state.category = category
            
        case .setIsDeleted(let isDeleted):
            state.isDeleted = isDeleted
            
        case .setCurrentPage(let page):
            state.currentPage = page
        
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
            
        case .setPostItem(let item):
            state.postItem = item
            state.communityItems.postItem = item
        case .setCommentItem(let item):
            state.commentItem = item
            state.communityItems.commentItem = item
        }
        
        return state
    }
}

extension QnADetailReactor {
    func setUpPostSection() -> Observable<Mutation> {
        return CommunityAPI.fetchCommunityDetail(currentState.communityId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                
                return .concat([
                    .just(.setCategory(data.category)),
                    .just(.setPostItem([data]))
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
}
