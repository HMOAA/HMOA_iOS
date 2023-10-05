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
        case viewDidLoad
        case didChangeTextViewEditing(String)
        case didEndTextViewEditing
        case didBeginEditing
        case didTapCommentWriteButton
    }
    
    enum Mutation {
        case setSections([QnADetailSection])
        case setCommentCount(Int)
        case setContent(String)
        case setIsEndEditing(Bool)
        case setIsBegenEditing(Bool)
        case setComment(CommunityComment)
        
    }
    
    struct State {
        var communityId: Int
        var sections: [QnADetailSection] = []
        var commentCount: Int = 0
        var isBeginEditing: Bool = false
        var isEndEditing: Bool = false
        var content: String = ""
    }
    
    init(_ id: Int) {
        initialState = State(communityId: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setUpPostSection(),
                setUpCommentSection()
            ])
            
        case .didBeginEditing:
            return .just(.setIsBegenEditing(true))
            
        case .didEndTextViewEditing:
            return .concat([
                .just(.setIsEndEditing(true)),
                .just(.setIsEndEditing(false))
            ])
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
            
        case .didTapCommentWriteButton:
            if !currentState.content.isEmpty || currentState.content != "댓글을 입력하세요" {
                return setPostComment()
            } else { return .empty() }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSections(let sections):
            state.sections = sections
            
        case .setCommentCount(let count):
            state.commentCount = count
            
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
            
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
            
            state.commentCount = currentState.commentCount + 1
            state.sections = section
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
                
                return .just(.setSections([section]))
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
                return .just(.setComment(data))
            }
    }
}
