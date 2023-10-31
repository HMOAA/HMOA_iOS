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
    let service: CommunityListProtocol?
    
    enum Action {
        case didTapOkButton
        case didChangeTitle(String)
        case didChangeTextViewEditing(String)
        case didBeginEditing
    }
    
    enum Mutation {
        case setTitle(String)
        case setContent(String)
        case setSucces
        case setIsPopVC(Bool)
    }
    
    struct State {
        var id: Int? = nil
        var isPopVC: Bool = false
        var isBeginEditing: Bool = false
        var content: String
        var title: String? = nil
        var category: String
        var okButtonEnable: Bool = false
    }
    
    init(communityId: Int?, content: String = "내용을 입력해주세요", title: String?, category: String, service: CommunityListProtocol?) {
        initialState = State(id: communityId,
                             content: content,
                             title: title,
                             category: category)
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            if let id = currentState.id {
                return editCommunityPost(id)
            } else {
                return postCommunityPost()
            }
            
        case .didChangeTitle(let title):
            return .just(.setTitle(title))
            
        case .didBeginEditing:
            if currentState.content == "내용을 입력해주세요" {
                return .just(.setContent(""))
            } else {
                return .empty()
            }
            
        case .didChangeTextViewEditing(let content):
            return .just(.setContent(content))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        case .setTitle(let title):
            state.title = title
            state.okButtonEnable = isOkButtonEnabled(content: currentState.content,
                                                     title: title)
            
        case .setContent(let content):
            state.content = content
            state.okButtonEnable = isOkButtonEnabled(content: content,
                                                     title: currentState.title ?? "")
            
        case .setSucces:
            break
            
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
        }
        
        return state
    }
}

extension CommunityWriteReactor {
    func postCommunityPost() -> Observable<Mutation> {
        
        let state = currentState
        
        guard let title = state.title else { return .empty() }
        if state.content.isEmpty || title.isEmpty {
            return .empty()
        }
        
        let params: [String: String] = [
            "category": state.category,
            "content": state.content,
            "title": title
        ]
        
        return CommunityAPI.postCommunityPost(params)
            .catch { _ in.empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    self.service!.updateCommunityList(to: CategoryList(communityId: data.id, category: data.category, title: data.title)).map { _ in .setSucces },
                    .just(.setIsPopVC(true)),
                    .just(.setIsPopVC(false))
                ])
            }
    }
    
    func editCommunityPost(_ id: Int) -> Observable<Mutation> {
        guard let title = currentState.title else { return .empty() }
        return CommunityAPI.putCommunityPost(
            id,
            [
                "content": currentState.content,
                "title": title
            ]
        )
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    self.service!.editCommunityList(to: CategoryList(
                        communityId: data.id,
                        category: data.category,
                        title: data.title
                    )).map { _ in .setSucces},
                    self.service!.editCommunityDetail(to: data)
                        .map { _ in .setSucces },
                    .just(.setIsPopVC(true)),
                    .just(.setIsPopVC(false))
                ])
            }
    }
    
    func isOkButtonEnabled(content: String, title: String ) -> Bool {
        
        let isContentEmpty = content.isEmpty
        let isContentInitValue = content == "내용을 입력해주세요"
        let isTitleEmpty = title.isEmpty
        
        return !(isContentEmpty || isTitleEmpty || isContentInitValue)
    }
}
