//
//  RegisterReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/06.
//

import UIKit

import ReactorKit
import RxCocoa

class RegisterReactor: Reactor {
    
    let initialState: State
    
    init() {
        initialState = State(isPresent: false, isPush: false)
    }
    
    enum Action {
        case didTapEmailChoiceButton
        case didTapNextButton
    }
    
    enum Mutation {
        case setPresentChoiceEmailVC(Bool)
        case setPushPwRegisterVC(Bool)
    }

    struct State {
        var isPresent: Bool
        var isPush: Bool
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .concat([
                .just(Mutation.setPushPwRegisterVC(true)),
                .just(Mutation.setPushPwRegisterVC(false))
            ])
        case .didTapEmailChoiceButton:
            return .concat([
                .just(Mutation.setPresentChoiceEmailVC(true)),
                .just(Mutation.setPresentChoiceEmailVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setPushPwRegisterVC(let isPush):
            state.isPush = isPush
        case .setPresentChoiceEmailVC(let isPresent):
            state.isPresent = isPresent
        }
        
        return state
    }
    
}
