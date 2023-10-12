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
        case didDeletedComment
        case didTapOptionButton(Int)
    }
    
    enum Mutation {
        case setSections([QnADetailSection])
        case setCategory(String)
        case setCommentCount(Int)
        case setContent(String)
        case setIsBegenEditing(Bool)
        case setComment(CommunityComment)
        case setSelectedCommentRow(Int?)
        case setIsEndEditing(Bool)
    }
    
    struct State {
        var communityId: Int
        var sections: [QnADetailSection] = []
        var commentCount: Int? = nil
        var isBeginEditing: Bool = false
        var content: String = ""
        var selectedCommentRow: Int? = nil
        var isEndEditing: Bool = false
        var category: String = ""
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
            
        case .didDeletedComment:
            return deleteCommentInSection()
            
        case .didTapOptionButton(let row):
            return .just(.setSelectedCommentRow(row))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSections(let sections):
            state.sections = sections
            
        case .setCommentCount(let count):
            state.commentCount = count
            
        case .setContent(let content):
            state.content = content
            
        case .setIsBegenEditing(let isBegin):
            state.isBeginEditing = isBegin
            
        case .setComment(let comment):
            var section = currentState.sections
            var commentItem = section[1].item
            commentItem.append(QnADetailSectionItem.commentCell(comment))
            let commentSection = QnADetailSection.comment(commentItem)
            section[1] = commentSection
            
            state.commentCount = currentState.commentCount! + 1
            state.sections = section
            
        case .setSelectedCommentRow(let row):
            state.selectedCommentRow = row
            
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
            
        case .setCategory(let category):
            state.category = category
        }
        
        return state
    }
}

extension QnADetailReactor {
    func setUpPostSection() -> Observable<Mutation> {
        return CommunityAPI.fetchCommunityDetail(currentState.communityId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let item = QnADetailSectionItem.qnaPostCell(data)
                let section = QnADetailSection.qnaPost([item])
                
                return .concat([
                    .just(.setCategory(data.category)),
                    .just(.setSections([section]))
                ])
            }
    }
    
    func setUpCommentSection() -> Observable<Mutation> {
        let query: [String: Int] =
        [
            "page": 0
        ]
        return CommunityAPI.fetchCommunityComment(currentState.communityId, query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var item = data.comments.map { QnADetailSectionItem.commentCell($0) }
                var section = self.currentState.sections
                
                if item.isEmpty { item = [QnADetailSectionItem.commentCell(nil)] }
                section.append(QnADetailSection.comment(item))
                
                return .concat([
                    .just(.setSections(section)),
                    .just(.setCommentCount(data.commentCount))
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
        var section = currentState.sections
        var commentItem = section[1].item
        commentItem.remove(at: row)
        let commentSection = QnADetailSection.comment(commentItem)
        section[1] = commentSection
        
        return .concat([
            .just(.setSections(section)),
            .just(.setSelectedCommentRow(nil)),
            .just(.setCommentCount(currentState.commentCount! - 1))
        ])
    }
}
