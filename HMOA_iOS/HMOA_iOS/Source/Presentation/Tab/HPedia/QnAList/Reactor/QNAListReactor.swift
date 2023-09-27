//
//  QNAListReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/09.
//

import ReactorKit
import RxSwift

class QNAListReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case viewWillAppear
        case didTapFloatingButton
        case didTapRecommendButton
        case didTapGiftButton
        case didTapEtcButton
        case didTapQnACell(IndexPath)
        case didChangedSearchText(String)
    }
    
    enum Mutation {
        case setIsTapFloatingButton(Bool)
        case setSelectedCategory(String?)
        case setSelectedPostId(IndexPath?)
        case setSearchText(String)
    }
    
    
    struct State {
        var selectedCategory: String? = nil
        var isFloatingButtonTap: Bool = false
        var selectedPostId: Int? = nil
        var items: [HPediaQnAData] = HPediaQnAData.list
        var searchText: String? = nil
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.setIsTapFloatingButton(false))
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
        case .didTapRecommendButton:
            return .concat([
                .just(.setSelectedCategory("추천")),
                .just(.setSelectedCategory(nil))
            ])
        case .didTapGiftButton:
            return .concat([
                .just(.setSelectedCategory("선물")),
                .just(.setSelectedCategory(nil))
            ])
        case .didTapEtcButton:
            return .concat([
                .just(.setSelectedCategory("기타")),
                .just(.setSelectedCategory(nil))
            ])
        case .didTapQnACell(let indexPath):
            return .concat([
                .just(.setSelectedPostId(indexPath)),
                .just(.setSelectedPostId(nil))
            ])
        case .didChangedSearchText(let text):
            return .just(.setSearchText(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
        case .setSelectedCategory(let category):
            state.selectedCategory = category
        case .setSelectedPostId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedPostId = nil
                return state
            }
            state.selectedPostId = currentState.items[indexPath.row].id
        case .setSearchText(let text):
            state.searchText = text
        }
        
        return state
    }
}
