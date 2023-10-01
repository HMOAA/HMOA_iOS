//
//  CommunityWriteReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/01.
//

import Foundation

import ReactorKit
import RxSwift

class CommunityWriteReactor: Reactor {
    var initialState: State
    
    enum Action {
        case didTapOkButton
        case didChangeTitle(String)
        case didChangeTextViewEditing(String)
        case didEndTextViewEditing
        case didBeginEditing
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setIsEndEditing(Bool)
    }
    
    struct State {
        var title: String = ""
        var isPopVC: Bool = false
        var isBeginEditing: Bool = false
        var isEndEditing: Bool = false
        var content: String = "내용을 입력해주세요"
        var category: String
    }
    
    init(category: String) {
        initialState = State(category: category)
        print(category)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            return postCommunityPost()
            
        case .didChangeTitle(let title):
            return .concat([
                .just(.setTitle(title))
            ])
        case .didBeginEditing:
            return .just(.setContent(""))
        
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
            
        case .setTitle(let title):
            state.title = title

        case .setIsEndEditing(let isEnd):
            state.isEndEditing = isEnd
            
        case .setContent(let content):
            state.content = content
        }
        
        return state
    }
}

extension CommunityWriteReactor {
    func postCommunityPost() -> Observable<Mutation> {
        
        let state = currentState
        if state.content.isEmpty || state.title.isEmpty {
            return .empty()
        }
        
        let params: [String: String] = [
            "category": state.category,
            "content": state.content,
            "title": state.title
        ]
        return CommunityAPI.postCommunityPost(params)
            .catch { _ in.empty() }
            .flatMap { _  -> Observable<Mutation> in
                return .empty()
            }
    }
}
