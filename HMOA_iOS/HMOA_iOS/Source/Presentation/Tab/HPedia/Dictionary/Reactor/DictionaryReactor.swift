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
    }
    
    enum Mutation {
        case setSelectedId(IndexPath?)
        case setItems([HPediaItem])
        case setLoadedPage(Int)
    }
    
    struct State {
        var type: HpediaType
        var title: String
        var items: [HPediaItem] = []
        var selectedId: Int? = nil
        var loadedPage: Set<Int> = []
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
            return setDictionaryItems(page)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedId(let indexPath):
            guard let indexPath = indexPath else {
                return state
            }
            state.selectedId = currentState.items[indexPath.row].id
        case .setItems(let items):
            state.items = items
            
        case .setLoadedPage(let page):
            state.loadedPage.insert(page)
        }
        return state
    }
}

extension DictionaryReactor {
    //TODO: - Paging
    func setDictionaryItems(_ page: Int) -> Observable<Mutation> {
        
        if currentState.loadedPage.contains(page) {
            return .empty()
        }
        
        let query = ["pageNum": page]
        
        
        switch currentState.type {
        case .term:
            return HPediaAPI.fetchTermList(query)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var currentItem = self.currentState.items
                    let item = data.data.map { $0.toHPediaItem() }
                    currentItem.append(contentsOf: item)
                    
                    return .concat([
                        .just(.setItems(currentItem)),
                        .just(.setLoadedPage(page))
                    ])
                }
        case .note:
            return HPediaAPI.fetchNoteList(query)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var currentItem = self.currentState.items
                    let item = data.data.map { $0.toHPediaItem() }
                    currentItem.append(contentsOf: item)
                    
                    return .concat([
                        .just(.setItems(currentItem)),
                        .just(.setLoadedPage(page))
                    ])
                }
        case .perfumer:
            return HPediaAPI.fetchPerfumerList(query)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var currentItem = self.currentState.items
                    let item = data.data.map { $0.toHPediaItem() }
                    currentItem.append(contentsOf: item)
                    
                    return .concat([
                        .just(.setItems(currentItem)),
                        .just(.setLoadedPage(page))
                    ])
                }
        case .brand:
            return HPediaAPI.fetchBrandList(query)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    var currentItem = self.currentState.items
                    let item = data.data.map { $0.toHPediaItem() }
                    currentItem.append(contentsOf: item)
                    
                    return .concat([
                        .just(.setItems(currentItem)),
                        .just(.setLoadedPage(page))
                    ])
                }
        }
    }
}
