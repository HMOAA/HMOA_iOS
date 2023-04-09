//
//  ChangeYearReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/31.
//

import UIKit

import ReactorKit
import RxCocoa

class ChangeYearReactor: Reactor {
    let initialState: State
    
    enum Action {
        case didTapChoiceYearButton
        case didTapChangeButton
    }
    
    enum Mutation {
        case setPresentChoiceYearVC(Bool)
        case setPopMyPage(Bool)
        case setSelectedYear(Bool)
    }
    
    struct State {
        var isPresentChoiceYearVC: Bool = false
        var isPopMyPage: Bool = false
        var isSelectedYear: Bool = false
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
        case .didTapChangeButton:
            return .concat([
                .just(.setPopMyPage(true)),
                .just(.setPopMyPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setPresentChoiceYearVC(let isPresent):
            state.isPresentChoiceYearVC = isPresent
        case .setPopMyPage(let isPop):
            state.isPopMyPage = isPop
        case .setSelectedYear(let isSelectedYear):
            state.isSelectedYear = isSelectedYear
        }
        
        return state
    }
}
        
