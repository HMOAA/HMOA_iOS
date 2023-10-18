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
        case didTapOptionButton(Int?, String?, String?, String, String?, Bool? = true)
        case didTapOptionCell(Int)
        case didTapCancleButton
    }
    
    enum Mutation {
        case setisHiddenOptionView(Bool)
        case setIsTapEdit(Bool)
        case setIsTapDelete(Bool)
        case setCommentInfo(Int, String)
        case setPostInfo(Int, String, String, String)
        case setType(String)
        case setOptions([String])
    }
    
    struct State {
        var options: [String] = []
        var isHiddenOptionView: Bool = true
        var isTapEdit: Bool = false
        var isTapDelete: Bool = false
        var commentInfo: (Int, String)? = nil
        var postInfo: (Int, String, String, String)? = nil
        var type: String = ""
        var category: String = ""
    }
    
    init() {
        initialState = State()
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackgroundView:
            return .just(.setisHiddenOptionView(true))
            
        case .didTapOptionButton(let id, let content, let title, let type, let category, let isWrited):
            guard let id = id else { return .empty() }
            guard let isWrited = isWrited else { return .empty()}
            
            if type == "Post" {
                return .concat([
                    .just(.setOptions(["수정", "삭제"])),
                    .just(.setType(type)),
                    .just(.setPostInfo(id, content!, title!, category!)),
                    .just(.setisHiddenOptionView(false))
                ])
            }
            else {
                if isWrited {
                    return .concat([
                        .just(.setOptions(["수정", "삭제"])),
                        .just(.setType(type)),
                        .just(.setCommentInfo(id, content!)),
                        .just(.setisHiddenOptionView(false))
                    ])
                } else {
                    return .concat([
                        .just(.setOptions(["신고"])),
                        .just(.setType(type)),
                        .just(.setCommentInfo(id, content!)),
                        .just(.setisHiddenOptionView(false))
                    ])
                }
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
                if let _ = currentState.commentInfo {
                    return deleteComment()
                } else {
                    return deletePost()
                }
                
            default: return .empty()
            }
            
        case .didTapCancleButton:
            return .just(.setisHiddenOptionView(true))
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
            
        case .setPostInfo(let id, let content, let title, let category):
            state.postInfo = (id, content, title, category)
            
        case .setType(let type):
            state.type = type
            
        case .setOptions(let options):
            state.options = options
        }
        
        return state
    }
    
    
}

extension OptionReactor {
    func deleteComment() -> Observable<Mutation> {
        return CommunityAPI.deleteCommunityComment(currentState.commentInfo!.0)
            .catch { _ in .empty() }
            .flatMap { _  -> Observable<Mutation> in
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false))
                ])
            }
    }
    
    func deletePost() -> Observable<Mutation> {
        return CommunityAPI.deleteCommunityPost(currentState.postInfo!.0)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                return .concat([
                    .just(.setisHiddenOptionView(true)),
                    .just(.setIsTapDelete(true)),
                    .just(.setIsTapDelete(false))
                ])
            }
    }
}
