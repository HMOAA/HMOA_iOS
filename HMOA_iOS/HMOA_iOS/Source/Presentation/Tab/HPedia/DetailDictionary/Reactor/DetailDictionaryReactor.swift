//
//  DetailDictionaryReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/26.
//

import Foundation

import ReactorKit
import RxSwift

class DetailDictionaryReactor: Reactor {
    var initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setItem(HPediaItem)
    }
    
    struct State {
        var type: HpediaType
        var id: Int
        var item: HPediaItem? = nil
    }
    
    init(_ type: HpediaType, _ id: Int) {
        initialState = State(type: type, id: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setHPediaDetail()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItem(let item):
            state.item = item
        }
        return state
    }
}

extension DetailDictionaryReactor {
    func setHPediaDetail() -> Observable<Mutation> {
        switch currentState.type {
        case .term:
            return HPediaAPI.fetchTermDetail(currentState.id)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let data = data.data[0].toHPediaItem()
                    return .just(.setItem(data))
                }
        case .note:
            return HPediaAPI.fetchNoteDetail(currentState.id)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let data = data.data[0].toHPediaItem()
                    return .just(.setItem(data))
                }
        case .perfumer:
            return HPediaAPI.fetchPerfumerDetail(currentState.id)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let data = data.data[0].toHPediaItem()
                    return .just(.setItem(data))
                }
        case .brand:
            return HPediaAPI.fetchBrandDetail(currentState.id)
                .catch { _ in .empty() }
                .flatMap { data -> Observable<Mutation> in
                    let data = data.data[0].toHPediaItem()
                    return .just(.setItem(data))
                }
        }
    }
}
