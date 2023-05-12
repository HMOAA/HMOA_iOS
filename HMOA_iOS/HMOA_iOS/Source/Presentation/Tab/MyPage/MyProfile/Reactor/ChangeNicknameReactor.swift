//
//  ChangeNicknameReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/07.
//

import ReactorKit

class ChangeNicknameReactor: Reactor {
    
    var initialState: State
    var service: UserServiceProtocol
    enum Action {
        case didTapDuplicateButton(String?)
        case didTapStartButton
        case didTapTextFieldReturn
    }
    
    enum Mutation {
        case setNickNameResponse(Response?)
        case setNickname(String)
        case setIsDuplicate(Bool)
        case setIsTapReturn(Bool)
        case dismiss
    }
    
    struct State {
        var isDuplicate: Bool? = nil
        var isEnable: Bool = false
        var isTapReturn: Bool = false
        var nickname: String? = nil
        var nicknameResponse: Response? = nil
        var shouldDismissed: Bool = false
    }
    
    init(service: UserServiceProtocol) {
        self.initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapDuplicateButton(let nickname):
            guard let nickname = nickname
            else { return .just(.setIsDuplicate(true))}
            
            if nickname.isEmpty { return .just(.setIsDuplicate(true))}
            
            return .concat([
                MemberAPI.checkDuplicateNickname(params: ["nickname": nickname])
                .map { .setIsDuplicate($0) },
                .just(.setNickname(nickname))
            ])
        case .didTapStartButton:
            guard let nickname = currentState.nickname
            else { return .just(.setNickNameResponse(nil)) }
            return .concat([
                MemberAPI.updateNickname(params: ["nickname": nickname])
                .map { .setNickNameResponse($0) },
                service.updateUserNickname(to: nickname).map { _ in .dismiss },
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
        case .dismiss:
            state.shouldDismissed = true
        }
        
        return state
    }
}

extension ChangeNicknameReactor {
//    func reactorForUserInformation() -> UserInformationReactor {
//        return UserInformationReactor(service: service)
//    }
}
