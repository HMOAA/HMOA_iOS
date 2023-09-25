//
//  CommentWriteReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import ReactorKit
import RxSwift

class CommentWriteReactor: Reactor {
    var initialState: State
    var service: UserCommentServiceProtocol? = nil
    
    enum Action {
        case didTapOkButton
        case didTapCancleButton
        case didChangeTextViewEditing(String)
        case didEndTextViewEditing
        case didBeginEditing
    }
    
    enum Mutation {
        case setIsEndEditing(Bool)
        case setIsPopVC(Bool)
        case setContent(String)
    }
    
    struct State {
        var content: String = "해당 제품에 대한 의견을 남겨주세요"
        var isWrite: Bool = false // 수정 or 새로 작성 상태
        var commentId: Int? = nil
        var perfumeId: Int
        var isPopVC: Bool = false
        var isBeginEditing: Bool = false
        var isEndEditing: Bool = false
    }
    
    init(perfumeId: Int, isWrite: Bool, content: String = "", service: UserCommentServiceProtocol? = nil, commentId: Int = 0) {
        // 수정인 경우
        if isWrite {
            self.initialState = State(content: content, isWrite: isWrite, commentId: commentId, perfumeId: perfumeId)
            self.service = service!
        } else { // 새로 댓글을 다는 경우
            self.initialState = State(perfumeId: perfumeId)
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            if !currentState.isWrite {
                return postCommentAndSetPopVC()
            } else {
                return modifyCommentAndSetPopVC()
            }
        case .didTapCancleButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
        case .didBeginEditing:
            var nowContent = ""

            if currentState.isWrite {
                nowContent = currentState.content
            }
            
            return .just(.setContent(nowContent))
        
        case .didEndTextViewEditing:
            return .concat([
                .just(.setIsEndEditing(true)),
                .just(.setIsEndEditing(false))
            ])
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
        case .setContent(let content):
            state.content = content
        }
        
        return state
    }
    
    // TODO: 수정 상태 or 작성 상태에 따라서 서버로 댓글 전달하기
}

extension CommentWriteReactor {
    
    func postCommentAndSetPopVC() -> Observable<Mutation> {
        let content = currentState.content
        return CommentAPI.postComment(
            ["content": content],
            currentState.perfumeId
        )
        .catch { _ in .empty() }
        .flatMap { _ -> Observable<Mutation> in
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
        }
    }
    
    func modifyCommentAndSetPopVC() -> Observable<Mutation> {
        let content = currentState.content
        
        return CommentAPI.modifyComment(
            ["content": content],
            currentState.commentId!)
        .catch { _ in .empty() }
        .flatMap { _ -> Observable<Mutation> in
            return .concat([
                self.service!.updateContent(to: content)
                    .map { _ in .setIsPopVC(true) },
                .just(.setIsPopVC(false))
                
            ])
        }
        
    }
}
