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
    
    enum Action {
        case didTapFloatingButton
    }
    
    enum Mutation {
        case setIsTapFloatingButton(Bool)
    }
    
    
    struct State {
        var isFloatingButtonTap: Bool = false
        var items: [HPediaQnAData] = HPediaQnAData.list
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
        }
        
        return state
    }
}
