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
        var isPresentChoiceYearVC: Bool
        var isCheckedWoman: Bool
        var isCheckedMan: Bool
        var isPresentTabBar: Bool
        var isSelectedYear: Bool
        var isSexCheck: Bool
    }
    
    init() {
        initialState = State(isPresentChoiceYearVC: false, isCheckedWoman: false, isCheckedMan: false, isPresentTabBar: false, isSelectedYear: false, isSexCheck: false)
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
            return .concat([
                .just(.setCheckMan(true)),
                .just(.setCheckWoman(false))
            ])
        case .didTapWomanButton:
            return .concat([
                .just(.setCheckWoman(true)),
                .just(.setCheckMan(false))
            ])
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
        case .setCheckWoman(let isChecked):
            state.isCheckedWoman = isChecked
        case .setPresentTabBar(let isPresent):
            state.isPresentTabBar = isPresent
        case .setSelectedYear(let isSelectedYear):
            state.isSelectedYear = isSelectedYear
        }
        
        state.isSexCheck = isCompleteStart(man: state.isCheckedMan,
                                           woman: state.isCheckedWoman)
        
        return state 
    }
    
    func isCompleteStart(man: Bool, woman: Bool) -> Bool {
        return man || woman
    }
}
