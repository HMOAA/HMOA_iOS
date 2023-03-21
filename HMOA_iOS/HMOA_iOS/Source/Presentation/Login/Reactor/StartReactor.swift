//
//  StartReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/10.
//

import UIKit

import ReactorKit
import RxCocoa

class StartReactor: Reactor {
    let initialState: State
    
    enum Action {
        case didTapChoiceYearButton
        case didTapWomanButton
        case didTapManButton
        case didTapStartButton
    }
    
    enum Mutation {
        case setPresentChoiceYearVC(Bool)
        case setCheckWoman(Bool)
        case setCheckMan(Bool)
        case setPresentTabBar(Bool)
        case setSelectedYear(Bool)
    }
    
    struct State {
        var isPresentChoiceYearVC: Bool = false
        var isCheckedWoman: Bool = false
        var isCheckedMan: Bool = false
        var isPresentTabBar: Bool = false
        var isSelectedYear: Bool = false
        var isSexCheck: Bool = false
    }
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapChoiceYearButton:
            return .concat([
                .just(.setPresentChoiceYearVC(true)),
                .just(.setSelectedYear(true)),
                .just(.setPresentChoiceYearVC(false))
            ])
        case .didTapManButton:
            return .just(.setCheckMan(true))
        case .didTapWomanButton:
            return .just(.setCheckWoman(true))
        case .didTapStartButton:
            return .concat([
                .just(.setPresentTabBar(true)),
                .just(.setPresentTabBar(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setPresentChoiceYearVC(let isPresent):
            state.isPresentChoiceYearVC = isPresent
        case .setCheckMan(let isChecked):
            state.isCheckedMan = isChecked
            state.isCheckedWoman = !isChecked
            state.isSexCheck = isChecked
        case .setCheckWoman(let isChecked):
            state.isCheckedWoman = isChecked
            state.isCheckedMan = !isChecked
            state.isSexCheck = isChecked
        case .setPresentTabBar(let isPresent):
            state.isPresentTabBar = isPresent
        case .setSelectedYear(let isSelectedYear):
            state.isSelectedYear = isSelectedYear
        }
        
        return state 
    }
}
        
