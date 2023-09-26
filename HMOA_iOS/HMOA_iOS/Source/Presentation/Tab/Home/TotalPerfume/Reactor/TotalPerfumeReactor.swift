//
//  TotalPerfumeReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import Foundation
import ReactorKit

class TotalPerfumeReactor: Reactor {
    
    enum Action {
        case didTapItem(RecommendPerfume)
    }
    
    enum Mutation {
        case setSelectedItem(RecommendPerfume?)
    }
    
    struct State {
        var section: [TotalPerfumeSection]
        var selectedItem: RecommendPerfume? = nil
    }
    
    var initialState: State
    
    init(_ listType: Int) {
        initialState = State(section: TotalPerfumeReactor.reqeustPerfumeList(listType))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapItem(let perfume):
            return .concat([
                .just(.setSelectedItem(perfume)),
                .just(.setSelectedItem(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedItem(let perfume):
            state.selectedItem = perfume
        }
        
        return state
    }
}

extension TotalPerfumeReactor {
    
    static func reqeustPerfumeList(_ listType: Int) -> [TotalPerfumeSection] {
    
        return []
    }
}
