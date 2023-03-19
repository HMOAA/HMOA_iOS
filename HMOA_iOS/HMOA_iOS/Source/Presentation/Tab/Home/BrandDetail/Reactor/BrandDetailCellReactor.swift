//
//  BrandDetailCellReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import ReactorKit
import RxSwift

class BrandDetailCellReactor: Reactor {
    
    var initialState: State

    enum Action {
        case didTapPerfumeLikeButton(Bool)
        case didTapCell(Perfume)
    }
    
    enum Mutation {
        case setPerfumeLike(Bool)
        case setSelectedCell(Perfume?)
    }
    
    struct State {
        var perfume: Perfume
        var selectedCell: Perfume? = nil
    }
    
    init(_ perfume: Perfume) {
        self.initialState = State(perfume: perfume)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapPerfumeLikeButton(let isLike):
            return .just(.setPerfumeLike(isLike))
            
        case .didTapCell(let perfume):
            return .concat([
                .just(.setSelectedCell(perfume)),
                .just(.setSelectedCell(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPerfumeLike(let isLike):
            state.perfume.isLikePerfume = isLike
        case .setSelectedCell(let perfume):
            state.selectedCell = perfume
        }
        
        return state
    }
}
