//
//  NicknameReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/22.
//

import ReactorKit
import RxCocoa

class NicknameReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapDuplicateButton(Bool?)
        case didTapStartButton
    }
    
    enum Mutation {
        case setIsDuplicate(Bool?)
        case setIsPushStartVC(Bool)
    }
    
    struct State {
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isPush: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDuplicateButton(let isEmpty):
            return .just(.setIsDuplicate(isEmpty))
        case .didTapStartButton:
            return .concat([
                .just(.setIsPushStartVC(true)),
                .just(.setIsPushStartVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsDuplicate(let isEmpty):
            state.isDuplicate = isEmpty
            state.isEnable = isEmpty == false
        case .setIsPushStartVC(let isPush):
            state.isPush = isPush
        }
        
        return state
    }
}
