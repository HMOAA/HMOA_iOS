//
//  OptionReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import RxSwift
import ReactorKit

final class OptionReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapBackgroundView
        case didTapOptionButton(Int?, String?, String)
        case didTapOptionCell(Int)
    }
    
    enum Mutation {
        case setisHiddenOptionView(Bool)
        case setIsTapEdit(Bool)
        case setIsTapDelete(Bool)
        case setCommentInfo(Int, String)
        case setPostInfo(Int, String)
        case setType(String)
    }
    
    struct State {
        var options: [String]
        var isHiddenOptionView: Bool = true
        var isTapEdit: Bool = false
        var isTapDelete: Bool = false
        var commentInfo: (Int, String)? = nil
        var postInfo: (Int, String)? = nil
        var type: String = ""
    }
    
    init(_ options: [String]) {
        initialState = State(options: options)
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackgroundView:
            return .just(.setisHiddenOptionView(true))
            
        case .didTapOptionButton(let id, let content, let type):
            guard let id = id else { return .empty() }
            
            if type == "Post" {
                return .concat([
                    .just(.setType(type)),
                    .just(.setPostInfo(id, content!)),
                    .just(.setisHiddenOptionView(false))
                ])
            }
            else {
                return .concat([
                    .just(.setType(type)),
                    .just(.setCommentInfo(id, content!)),
                    .just(.setisHiddenOptionView(false))
                ])
            }
            
        case .didTapOptionCell(let item):
            let selectedOption = currentState.options[item]
            switch selectedOption {
            case "수정":
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapEdit(true)),
                    .just(.setIsTapEdit(false))
                ])
                
            case "삭제":
                return deleteComment()
            default: return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
            
        case .setisHiddenOptionView(let isHidden):
            state.isHiddenOptionView = isHidden
            
        case .setIsTapEdit(let isTap):
            state.isTapEdit = isTap
        
        case .setIsTapDelete(let isTap):
            state.isTapDelete = isTap
            
        case .setCommentInfo(let id, let content):
            state.commentInfo = (id, content)
            
        case .setPostInfo:
            break
            
        case .setType(let type):
            state.type = type
        }
        
        return state
    }
    
    
}

extension OptionReactor {
    func deleteComment() -> Observable<Mutation> {
        return CommunityAPI.deleteCommunityComment(currentState.commentInfo!.0)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false))
                ])
            }
    }
}
