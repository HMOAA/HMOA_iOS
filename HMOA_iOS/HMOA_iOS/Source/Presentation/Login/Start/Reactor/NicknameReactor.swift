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
        case setNickNameResponse(NicknameResponse?)
        case setNickname(String)
        case setIsDuplicate(Bool)
        case setIsTapReturn(Bool)
    }
    
    struct State {
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isTapReturn: Bool = false
        var nickname: String? = nil
        var nicknameResponse: NicknameResponse? = nil
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
            
            return .concat([
                API.checkDuplicateNickname(params: ["nickname": nickname])
                .map { .setIsDuplicate($0) },
                .just(.setNickname(nickname))
            ])
        case .didTapStartButton:
            guard let nickname = currentState.nickname
            else { return .just(.setNickNameResponse(nil)) }
            print(nickname)
            return .concat([
                API.updateNickname(params: ["nickname": nickname])
                .map { .setNickNameResponse($0) },
                .just(.setNickNameResponse(nil))
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
        case .setIsTapReturn(let isTapReturn):
            state.isTapReturn = isTapReturn
        case .setNickname(let nickname):
            state.nickname = nickname
        case .setNickNameResponse(let response):
            state.nicknameResponse = response
        }
        
        return state
    }
}
