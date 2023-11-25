//
//  ChangeSexReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/31.

import UIKit

import ReactorKit
import RxCocoa

class ChangeSexReactor: Reactor {
    let initialState: State
    var service: UserServiceProtocol
    
    enum Action {
        case didTapWomanButton
        case didTapManButton
        case didTapChangeButton
    }
    
    enum Mutation {
        case setCheckWoman(Bool)
        case setCheckMan(Bool)
        case setPopMyPage(Bool)
    }
    
    struct State {
        var isCheckedWoman: Bool = false
        var isCheckedMan: Bool = false
        var isPopMyPage: Bool = false
        var isSexCheck: Bool = true
        var sexType: Bool? = false
    }
    
    init(_ currentType: Bool = false, service: UserServiceProtocol) {
        self.initialState = currentType ? State(isCheckedMan: true) : State(isCheckedWoman: true)
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapManButton:
            return .just(.setCheckMan(true))
        case .didTapWomanButton:
            return .just(.setCheckWoman(true))
        case .didTapChangeButton:
            
            guard let sex = currentState.sexType else { return .empty() }
            
            return .concat([
                ChangeSexReactor.patchUserSex(sex),
                service.updateUserSex(to: sex).map { _ in .setPopMyPage(false)}
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setCheckMan(let isChecked):
            state.isCheckedMan = isChecked
            state.isCheckedWoman = !isChecked
            state.isSexCheck = isChecked
            state.sexType = true // 남성은 true
        case .setCheckWoman(let isChecked):
            state.isCheckedWoman = isChecked
            state.isCheckedMan = !isChecked
            state.isSexCheck = isChecked
            state.sexType = false // 여성은 false
        case .setPopMyPage(let isPop):
            state.isPopMyPage = isPop
        }
        
        return state
    }
}

extension ChangeSexReactor {
    
    static func patchUserSex(_ type: Bool) -> Observable<Mutation> {

        return MemberAPI.updateSex(params: ["sex": type])
            .catch { _ in .empty() }
            .flatMap { response -> Observable<Mutation> in
                return .just(.setPopMyPage(true))
            }
    }
}
        
