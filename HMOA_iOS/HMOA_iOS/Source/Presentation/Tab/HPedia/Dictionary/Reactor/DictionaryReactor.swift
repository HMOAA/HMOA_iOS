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
    }
    
    enum Mutation {
        case setSelectedId(IndexPath?)
    }
    
    struct State {
        var id: Int
        var title: String
        var items: [DictionaryData] = DictionaryData.data
        var selectedTitle: String? = nil
    }
    
    init(id: Int) {
        initialState = State(id: id,
                             title: HPediaDictionaryData.list[id - 1].title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapItem(let indexPath):
            return .concat([
                .just(.setSelectedId(indexPath)),
                .just(.setSelectedId(nil))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = initialState
        
        switch mutation {
        case .setSelectedId(let indexPath):
            guard let indexPath = indexPath else {
                return state
            }
            state.selectedTitle = DictionaryData.data[indexPath.item].koreanName
        }
        return state
    }
}
