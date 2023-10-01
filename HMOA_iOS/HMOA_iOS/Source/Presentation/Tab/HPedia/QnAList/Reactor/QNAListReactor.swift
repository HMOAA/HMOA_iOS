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
        case didTapReviewButton
        case didTapGiftButton
        case didTapEtcButton
        case didTapQnACell(IndexPath)
        case didChangedSearchText(String)
        case didTapCategoryButton(String)
    }
    
    enum Mutation {
        case setIsTapFloatingButton(Bool)
        case setSelectedAddCategory(String?)
        case setSelectedPostId(IndexPath?)
        case setSearchText(String)
        case setPostList([CategoryList])
        case setSelectedCategory(String)
    }
    
    
    struct State {
        var selectedAddCategory: String? = nil
        var isFloatingButtonTap: Bool = false
        var selectedPostId: Int? = nil
        var items: [CategoryList] = []
        var searchText: String? = nil
        var selectedCategory: String = "추천"
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                .just(.setIsTapFloatingButton(false)),
                setCommunityListItem(currentState.selectedCategory)
            ])
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
        case .didTapReviewButton:
            return .concat([
                .just(.setSelectedAddCategory("추천")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapGiftButton:
            return .concat([
                .just(.setSelectedAddCategory("선물")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapEtcButton:
            return .concat([
                .just(.setSelectedAddCategory("기타")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapQnACell(let indexPath):
            return .concat([
                .just(.setSelectedPostId(indexPath)),
                .just(.setSelectedPostId(nil))
            ])
        case .didChangedSearchText(let text):
            return .just(.setSearchText(text))
            
        case .didTapCategoryButton(let category):
            return setCommunityListItem(category)
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
        case .setSelectedAddCategory(let category):
            state.selectedAddCategory = category
        case .setSelectedPostId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedPostId = nil
                return state
            }
            state.selectedPostId = 1
        case .setSearchText(let text):
            state.searchText = text
        case .setPostList(let item):
            state.items = item
        case .setSelectedCategory(let category):
            state.selectedCategory = category
        }
        
        return state
    }
}

extension QNAListReactor {
    func setCommunityListItem(_ category: String) -> Observable<Mutation> {
        
        let query: [String: Any] = [
            "category": category,
            "page": 0
        ]
        return CommunityAPI.fetchPostListsByCaetgory(query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let postList: [CategoryList]
                postList = data
                
                return .concat([
                    .just(.setPostList(postList)),
                    .just(.setSelectedCategory(category))
                ])
            }
    }
}
