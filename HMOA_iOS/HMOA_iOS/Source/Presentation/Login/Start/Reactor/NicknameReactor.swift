//
//  NicknameReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/22.
//

import ReactorKit

class NicknameReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapDuplicateButton
        case didTapStartButton
        case didTapTextFieldReturn
        case didBeginEditingNickname(String)
    }
    
    enum Mutation {
        case setIsPushNextVC(Bool)
        case setNickname(String)
        case setIsDuplicate(Bool)
        case setIsTapReturn(Bool)
    }
    
    struct State {
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isTapReturn: Bool = false
        var nickname: String? = nil
        var isPushNextVC: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDuplicateButton:
            guard let nickname = currentState.nickname
            else { return .just(.setIsDuplicate(true))}
            
            if nickname.isEmpty { return .just(.setIsDuplicate(true))}
            
            return .concat([
                MemberAPI.checkDuplicateNickname(params: ["nickname": nickname])
                .map { .setIsDuplicate($0) },
                .just(.setNickname(nickname))
            ])
        case .didTapStartButton:
            guard let nickname = currentState.nickname
            else { return .just(.setIsPushNextVC(false)) }
            return .concat([
                .just(.setIsPushNextVC(true)),
                .just(.setIsPushNextVC(false))
            ])
        case .didTapTextFieldReturn:
            return .concat([
                .just(.setIsTapReturn(true)),
                .just(.setIsTapReturn(false))
            ])
            
        case .didBeginEditingNickname(let nickname):
            return .just(.setNickname(nickname))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsDuplicate(let isDuplicate):
            state.isDuplicate = isDuplicate
            state.isEnable = isDuplicate == false
        case .setIsTapReturn(let isTapReturn):
            state.isTapReturn = isTapReturn
        case .setNickname(let nickname):
            state.nickname = nickname
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}
