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
    }
    
    enum Mutation {
        case setSelectedId(IndexPath?)
        case setItems([HPediaItem])
    }
    
    struct State {
        var type: HpediaType
        var title: String
        var items: [HPediaItem] = []
        var selectedId: Int? = nil
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
            return setDictionaryItems()
            
        case .didTapItem(let indexPath):
            return .concat([
                .just(.setSelectedId(indexPath)),
                .just(.setSelectedId(nil))
            ])
            
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
        }
        return state
    }
}

extension DictionaryReactor {
    //TODO: - Paging
    func setDictionaryItems() -> Observable<Mutation> {
        switch currentState.type {
        case .term:
            return HPediaAPI.fetchTermList()
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let item = data.data.map { $0.toHPediaItem() }
                    return .just(.setItems(item))
                }
        case .note:
            return HPediaAPI.fetchNoteList()
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let item = data.data.map { $0.toHPediaItem() }
                    return .just(.setItems(item))
                }
        case .perfumer:
            return HPediaAPI.fetchPerfumerList()
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let item = data.data.map { $0.toHPediaItem() }
                    return .just(.setItems(item))
                }
        case .brand:
            return HPediaAPI.fetchBrandList()
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let item = data.data.map { $0.toHPediaItem() }
                    return .just(.setItems(item))
                }
        }
    }
}
