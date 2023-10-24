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
    let service: CommunityListService
    
    enum Action {
        case viewWillAppear
        case viewDidLoad
        case didTapFloatingButton
        case didTapRecommendButton
        case didTapReviewButton
        case didTapEtcButton
        case didTapQnACell(IndexPath)
        case didChangedSearchText(String)
        case didTapCategoryButton(String)
        case willDisplayCell(Int)
    }
    
    enum Mutation {
        case setIsTapFloatingButton(Bool)
        case setSelectedAddCategory(String?)
        case setSelectedPostId(IndexPath?)
        case setSearchText(String)
        case setPostList([CategoryList])
        case setLoadedPage(Set<Int>)
        case setSelectedCategory(String)
        case setcurrentPage(Int)
        case editCommunityList(CategoryList)
        case addCommunityList(CategoryList)
        case deleteCommunityList(CategoryList)
    }
    
    
    struct State {
        var selectedAddCategory: String? = nil
        var isFloatingButtonTap: Bool = false
        var selectedPostId: Int? = nil
        var searchText: String? = nil
        var loadedPage: Set<Int> = []
        var selectedCategory: String = "추천"
        var items: [CategoryList] = []
        var currentPage: Int = 0
    }
    
    init(service: CommunityListService) {
        initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.setIsTapFloatingButton(false))
            
        case .viewDidLoad:
            return setCommunityListItem("추천", currentState.currentPage)
            
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            
        case .didTapRecommendButton:
            return .concat([
                .just(.setSelectedAddCategory("추천")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapReviewButton:
            return .concat([
                .just(.setSelectedAddCategory("시향기")),
                .just(.setSelectedAddCategory(nil))
            ])
        case .didTapEtcButton:
            return .concat([
                .just(.setSelectedAddCategory("자유")),
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
            return setCommunityListItem(category, 0)
            
        case .willDisplayCell(let page):
            return setCommunityListItem(currentState.selectedCategory, page)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
        case .setSelectedAddCategory(let category):
            state.selectedAddCategory = category
            state.loadedPage.remove(state.currentPage)
        case .setSelectedPostId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedPostId = nil
                return state
            }
            state.selectedPostId = currentState.items[indexPath.row].communityId
        case .setSearchText(let text):
            state.searchText = text
        case .setPostList(let item):
            state.items = item
        case .setLoadedPage(let loadedPage):
            state.loadedPage = loadedPage
        case .setSelectedCategory(let category):
            state.selectedCategory = category
        case .setcurrentPage(let page):
            state.currentPage = page
        case .editCommunityList(let community):
            break
        case .addCommunityList(let community):
            state.items.append(community)
        case .deleteCommunityList(let community):
            break
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .addCommunityList(let community):
                return .just(.addCommunityList(community))
            case .deleteCommunityList(let community):
                return .just(.deleteCommunityList(community))
            case .editCommunityList(let community):
                return .just(.editCommunityList(community))
            }
        }
        
        return .merge(mutation, eventMutation)
    }
}

extension QNAListReactor {
    func setCommunityListItem(_ category: String, _ page: Int) -> Observable<Mutation> {
        var loadedPage = currentState.loadedPage
        
        if category != currentState.selectedCategory {
            loadedPage = []
        }
        else if loadedPage.contains(page) { return .empty() }
        
        let query: [String: Any] = [
            "category": category,
            "page": page
        ]
        
        return CommunityAPI.fetchPostListsByCaetgory(query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                var postList = self.currentState.items
                if page == 0 { postList = [] }
                
                postList.append(contentsOf: data)
                loadedPage.insert(page)
                
                return .concat([
                    .just(.setPostList(postList)),
                    .just(.setLoadedPage(loadedPage)),
                    .just(.setSelectedCategory(category)),
                    .just(.setcurrentPage(page))
                ])
            }
    }
    
    func reactorForWrite() -> CommunityWriteReactor {
        return CommunityWriteReactor(
            communityId: nil,
            title: nil,
            category: currentState.selectedAddCategory!,
            service: service)
    }
    
    func reactorForDetail() -> QnADetailReactor {
        return QnADetailReactor(
            currentState.selectedPostId!,
            service
        )
    }
}
