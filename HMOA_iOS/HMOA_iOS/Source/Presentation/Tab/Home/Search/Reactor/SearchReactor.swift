//
//  SearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import ReactorKit
import RxSwift

class SearchReactor: Reactor {
    
    enum Action {
        case didTapBackButton
        case didChangeTextField
        case didEndTextField
    }
    
    enum Mutation {
        case isPopVC(Bool)
        case isChangeToResultVC(Bool)
        case isChangeToListVC(Bool)
    }
    
    struct State {
        var Content: String = ""
        var isPopVC: Bool = false
        var isChangeTextField: Bool = false
        var isEndTextField: Bool = false
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.isPopVC(true)),
                .just(.isPopVC(false))
            ])
        case .didChangeTextField:
            return .concat([
                .just(.isChangeToListVC(true)),
                .just(.isChangeToListVC(false))
            ])
        case .didEndTextField:
            return .concat([
                .just(.isChangeToResultVC(true)),
                .just(.isChangeToResultVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isPopVC(let isPop):
            state.isPopVC = isPop
        case .isChangeToListVC(let isChange):
            state.isChangeTextField = isChange
        case .isChangeToResultVC(let isEnd):
            state.isEndTextField = isEnd
        }
        
        return state
    }
}
