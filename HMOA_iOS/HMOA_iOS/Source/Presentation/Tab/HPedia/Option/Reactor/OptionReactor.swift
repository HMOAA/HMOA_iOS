//
//  OptionReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import RxSwift
import ReactorKit

final class OptionReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapBackgroundView
        case didTapOptionButton
    }
    
    enum Mutation {
        case setisHiddenOptionView(Bool)
    }
    
    struct State {
        var options: [String]
        var isHiddenOptionView: Bool = true
    }
    
    init(_ options: [String]) {
        initialState = State(options: options)
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackgroundView:
            return .just(.setisHiddenOptionView(true))
        case .didTapOptionButton:
            return .just(.setisHiddenOptionView(false))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setisHiddenOptionView(let isHidden):
            state.isHiddenOptionView = isHidden
        }
        
        return state
    }
    
    
}
