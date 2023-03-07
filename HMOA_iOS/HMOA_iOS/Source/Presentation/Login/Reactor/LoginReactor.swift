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
        case didTapLoginButton
        case didTapRegisterButton
        case didTapLoginRetainButton
        case didTapNoLoginButton
    }
    
    //상태 변화
    enum Mutation {
        case setPresentTabBar(Bool)
        case setPushRegisterVC(Bool)
        case toggleRetainButton(Bool)
    }
    
    //현재 뷰 상태
    struct State {
        var isPushRegisterVC: Bool
        var isPresentTabBar: Bool
        var isChecked: Bool
    }
    
    init() {
        initialState = State(isPushRegisterVC: false, isPresentTabBar: false, isChecked: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapLoginButton,
             .didTapNoLoginButton:
            return .concat([
                .just(.setPresentTabBar(true)),
                .just(.setPresentTabBar(false))
                      ])
        case .didTapRegisterButton:
            return .concat([
                .just(.setPushRegisterVC(true)),
                .just(.setPushRegisterVC(false))
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
        case .setPresentTabBar(let isPresent):
            state.isPresentTabBar = isPresent
        case .setPushRegisterVC(let isPush):
            state.isPushRegisterVC = isPush
        case .toggleRetainButton(let isCheck):
            state.isChecked = isCheck
        }
        
        return state
    }
    
}
