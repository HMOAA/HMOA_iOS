//
//  DictionaryReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import Foundation

import ReactorKit
import RxSwift

class DictionaryReactor: Reactor {
    let initialState: State
    
    enum Action {
        case didTapItem(IndexPath)
        case viewDidLoad
        case willDisplayCell(Int)
        case didSearchItem(String)
    }
    
    enum Mutation {
        case setSelectedId(IndexPath?)
        case setListItems([HPediaItem])
        case setSearchedItems([HPediaItem])
        case setLoadedPage(Int)
        case setLoadedSearchPage(Int)
        case setIsSearch(String)
    }
    
    struct State {
        var type: HpediaType
        var title: String
        var items: [HPediaItem] {
            if isSearch {
                return searchedItems
            } else {
                return listItems
            }
        }
        var isSearch: Bool = false
        var listItems: [HPediaItem] = []
        var searchedItems: [HPediaItem] = []
        var selectedId: Int? = nil
        var loadedPage: Set<Int> = []
        var loadedSearchPage: Set<Int> = []
        var searchedText: String = ""
    }
    
    init(type: HpediaType) {
        initialState = State(
            type: type,
            title: type.title
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            return setDictionaryItems(0)
            
        case .didTapItem(let indexPath):
            return .concat([
                .just(.setSelectedId(indexPath)),
                .just(.setSelectedId(nil))
            ])
            
        case .willDisplayCell(let page):
            if currentState.isSearch {
                return setUpSearchedItems(page, currentState.searchedText)
            } else {
                return setDictionaryItems(page)
            }
            
        case .didSearchItem(let text):
            return setUpSearchedItems(0, text)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedId(let indexPath):
            guard let indexPath = indexPath else {
                state.selectedId = nil
                return state
            }
            state.selectedId = currentState.items[indexPath.row].id
            
        case .setListItems(let items):
            state.listItems = items
            
        case .setLoadedSearchPage(let page):
            state.loadedSearchPage.insert(page)
            
        case .setSearchedItems(let items):
            state.searchedItems = items
            
        case .setIsSearch(let text):
            state.searchedText = text
            state.isSearch = !text.isEmpty
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
        }
        return state
    }
}

extension DictionaryReactor {
    
    func setDictionaryItems(_ page: Int) -> Observable<Mutation> {
        
        if currentState.loadedPage.contains(page) {
            return .empty()
        }
        
        let query = ["pageNum": page]
        
        
        return currentState.type.listApi(query)
            .flatMap { data -> Observable<Mutation> in
                var currentItem = self.currentState.listItems
                currentItem.append(contentsOf: data)
                
                return .concat([
                    .just(.setListItems(currentItem)),
                    .just(.setLoadedPage(page))
                ])
            }
    }
    
    func setUpSearchedItems(_ page: Int, _ text: String) -> Observable<Mutation> {
        
        
        if page != 0 && currentState.loadedSearchPage.contains(page) {
            return .empty()
        }
        
        let query: [String: Any] = [
            "page": page,
            "seachWord": text
        ]
        
        return currentState.type.searchApi(query)
            .flatMap { data -> Observable<Mutation> in
                if page == 0 {
                    return .concat([
                        .just(.setSearchedItems(data)),
                        .just(.setLoadedSearchPage(page)),
                        .just(.setIsSearch(text))
                    ])
                } else {
                    var currentItem = self.currentState.searchedItems
                    currentItem.append(contentsOf: data)
                    return .concat([
                        .just(.setSearchedItems(currentItem)),
                        .just(.setLoadedSearchPage(page)),
                        .just(.setIsSearch(text))
                    ])
                }
            }
    }
}
