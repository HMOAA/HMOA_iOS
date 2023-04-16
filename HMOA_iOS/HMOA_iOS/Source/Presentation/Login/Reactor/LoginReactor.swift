//
//  LoginReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/06.
//

import UIKit

import ReactorKit
import RxCocoa

class LoginReactor: Reactor {
    
    let initialState: State
    
    //유저 액션
    enum Action {
        case didTapGoogleLoginButton
        case didTapAppleLoginButton
        case didTapKakaoLoginButton
        case didTapLoginRetainButton
        case didTapNoLoginButton
    }
    
    //상태 변화
    enum Mutation {
        case setPresentTabBar(Bool)
        case setPushStartVC(Bool)
        case setSignInGoogle(Bool)
        case toggleRetainButton(Bool)
    }
    
    //현재 뷰 상태
    struct State {
        var isSignInGoogle: Bool = false
        var isPushStartVC: Bool = false
        var isPresentTabBar: Bool = false
        var isChecked: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNoLoginButton:
            return .concat([
                .just(.setPresentTabBar(true)),
                .just(.setPresentTabBar(false))
                      ])
        case .didTapGoogleLoginButton:
            return .concat([
                .just(.setSignInGoogle(true)),
                .just(.setSignInGoogle(false))
                      ])
        case .didTapAppleLoginButton:
            return .concat([
                .just(.setPushStartVC(true)),
                .just(.setPushStartVC(false))
                      ])
        case .didTapKakaoLoginButton:
            return .concat([
                .just(.setPushStartVC(true)),
                .just(.setPushStartVC(false))
                      ])
        case .didTapLoginRetainButton:
            return .concat([
                .just(.toggleRetainButton(true)),
                .just(.toggleRetainButton(false))
                      ])
        }
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSignInGoogle(let isSignIn):
            state.isSignInGoogle = isSignIn
        case .setPresentTabBar(let isPresent):
            state.isPresentTabBar = isPresent
        case .setPushStartVC(let isPush):
            state.isPushStartVC = isPush
        case .toggleRetainButton(let isCheck):
            state.isChecked = isCheck
        }
        
        return state
    }
    
}

extension LoginReactor {
}
