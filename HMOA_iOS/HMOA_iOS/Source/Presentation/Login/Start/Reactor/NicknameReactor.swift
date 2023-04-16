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
        case didTapDuplicateButton(String?)
        case didTapStartButton
        case didTapTextFieldReturn
    }
    
    enum Mutation {
        case setIsDuplicate(Bool)
        case setIsPushStartVC(Bool)
        case setIsTapReturn(Bool)
    }
    
    struct State {
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isPush: Bool = false
        var isTapReturn: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDuplicateButton(let nickname):
            guard let nickname = nickname
            else { return .just(.setIsDuplicate(true))}
            if nickname.isEmpty { return .just(.setIsDuplicate(true))}
            return API.checkDuplicateNickname(params: ["nickname": nickname])
                .map { .setIsDuplicate($0) }
        case .didTapStartButton:
            return .concat([
                .just(.setIsPushStartVC(true)),
                .just(.setIsPushStartVC(false))
            ])
        case .didTapTextFieldReturn:
            return .concat([
                .just(.setIsTapReturn(true)),
                .just(.setIsTapReturn(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsDuplicate(let isDuplicate):
            state.isDuplicate = isDuplicate
            state.isEnable = isDuplicate == false
        case .setIsPushStartVC(let isPush):
            state.isPush = isPush
        case .setIsTapReturn(let isTapReturn):
            state.isTapReturn = isTapReturn
        }
        
        return state
    }
}
