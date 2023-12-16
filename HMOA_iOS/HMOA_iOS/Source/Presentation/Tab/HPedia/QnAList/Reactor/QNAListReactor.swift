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
        case viewDidLoad(Bool)
        case didTapFloatingButton
        case didTapRecommendButton
        case didTapReviewButton
        case didTapEtcButton
        case didTapQnACell(IndexPath)
        case didChangedSearchText(String)
        case didTapCategoryButton(String)
        case willDisplayCell(Int)
        case didTapFloatingBackView
        case didTapSearchButton
    }
    
    enum Mutation {
        case setIsTapFloatingButton(Bool)
        case setSelectedAddCategory(String?)
        case setSelectedPostId(IndexPath?)
        case setSearchText(String)
        case setListItems([CategoryList])
        case setSearchedItems([CategoryList])
        case setLoadedListPage(Set<Int>)
        case setLoadedSearchPage(Int)
        case setSelectedCategory(String)
        case editCommunityList(CategoryList)
        case addCommunityList(CategoryList)
        case deleteCommunityList(CategoryList)
        case setIsLogin(Bool)
        case setIsTapWhenNotLogin(Bool)
        case setIsHiddenKeyboard(Bool)
    }
    
    
    struct State {
        var selectedAddCategory: String? = nil
        var isFloatingButtonTap: Bool = false
        var selectedPostId: Int? = nil
        var searchText: String = ""
        var loadedListPage: Set<Int> = []
        var loadedSearchPage: Set<Int> = []
        var selectedCategory: String = "추천"
        var items: [CategoryList] {
            if isSearch {
                searchedItems
            } else { listItems }
        }
        var searchedItems: [CategoryList] = []
        var listItems: [CategoryList] = []
        var isLogin: Bool = false
        var isTapWhenNotLogin: Bool = false
        var isSearch: Bool = false
        var isHiddenKeyboard: Bool = false
    }
    
    init(service: CommunityListService) {
        initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .just(.setIsTapFloatingButton(false))
            
        case .viewDidLoad(let isLogin):
            return .concat([
                setCommunityListItem("추천", 0),
                .just(.setIsLogin(isLogin))
            ])
            
        case .didTapFloatingButton:
            if currentState.isLogin {
                return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            } else {
                return .concat([
                    .just(.setIsTapWhenNotLogin(true)),
                    .just(.setIsTapWhenNotLogin(false))
                ])
            }
            
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
            return setUpSearchedItem(0, text)
            
        case .didTapCategoryButton(let category):
            return setCommunityListItem(category, 0)
            
        case .willDisplayCell(let page):
            if !currentState.isSearch {
                return setCommunityListItem(currentState.selectedCategory, page)
            } else {
                return setUpSearchedItem(page, currentState.searchText)
            }
            
        case .didTapFloatingBackView:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            
        case .didTapSearchButton:
            return .concat([
                .just(.setIsHiddenKeyboard(true)),
                .just(.setIsHiddenKeyboard(false))
            ])
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
            state.selectedPostId = currentState.items[indexPath.row].communityId
        case .setSearchText(let text):
            state.searchText = text
            state.isSearch = !text.isEmpty
        case .setListItems(let item):
            state.listItems = item
        case .setLoadedListPage(let loadedPage):
            state.loadedListPage = loadedPage
        case .setSelectedCategory(let category):
            state.selectedCategory = category
        case .editCommunityList(let community):
            if let index = state.listItems.firstIndex(where: { $0.communityId == community.communityId }) {
                state.listItems[index] = community
            }
        case .addCommunityList(let community):
            state.listItems.insert(community, at: 0)
        case .deleteCommunityList(let community):
            state.listItems.removeAll { $0.communityId == community.communityId }
        case .setIsLogin(let isLogin):
            state.isLogin = isLogin
        case .setIsTapWhenNotLogin(let isTap):
            state.isTapWhenNotLogin = isTap
        case .setSearchedItems(let items):
            state.searchedItems = items
        case .setLoadedSearchPage(let page):
            state.loadedSearchPage.insert(page)
        case .setIsHiddenKeyboard(let isHidden):
            state.isHiddenKeyboard = isHidden
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
            default: return .empty()
            }
        }
        
        return .merge(mutation, eventMutation)
    }
}

extension QNAListReactor {
    func setCommunityListItem(_ category: String, _ page: Int) -> Observable<Mutation> {
        
        var loadedPage = currentState.loadedListPage
        
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
                    .just(.setListItems(postList)),
                    .just(.setLoadedListPage(loadedPage)),
                    .just(.setSelectedCategory(category))
                ])
            }
    }
    
    func setUpSearchedItem(_ page: Int, _ text: String) -> Observable<Mutation> {
        if page != 0 && currentState.loadedSearchPage.contains(page) {
            return .empty()
        }
        
        let query: [String: Any] = [
            "page": page,
            "seachWord": text
        ]
        
        return SearchAPI.fetchCommunity(query: query)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                if page == 0 {
                    return .concat([
                        .just(.setSearchedItems(data)),
                        .just(.setLoadedSearchPage(page)),
                        .just(.setSearchText(text))
                    ])
                } else {
                    var currentItem = self.currentState.searchedItems
                    currentItem.append(contentsOf: data)
                    return .concat([
                        .just(.setSearchedItems(currentItem)),
                        .just(.setLoadedSearchPage(page)),
                        .just(.setSearchText(text))
                    ])
                }
            }
    }
    
    func reactorForWrite() -> CommunityWriteReactor {
        return CommunityWriteReactor(
            communityId: nil,
            title: nil,
            category: currentState.selectedAddCategory!,
            photos: [],
            service: service)
    }
    
    func reactorForDetail() -> QnADetailReactor {
        return QnADetailReactor(
            currentState.selectedPostId!,
            service
        )
    }
}
