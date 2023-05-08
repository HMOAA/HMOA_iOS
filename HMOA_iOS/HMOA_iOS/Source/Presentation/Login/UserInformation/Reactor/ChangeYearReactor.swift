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
    var initialState: State
    var service: UserYearServiceProtocol

    enum Action {
        case didTapChoiceYearButton
        case didTapChangeButton
        case didChangeSelectedYear(String)
    }
    
    enum Mutation {
        case setPresentChoiceYearVC(Bool)
        case setPopMyPage(Bool)
        case setIsSelectedYear(Bool)
        case setSelectedYear(String?)
    }
    
    struct State {
        var isPresentChoiceYearVC: Bool = false
        var isPopMyPage: Bool = false
        var isSelectedYear: Bool = false
        var selectedYear: String? = nil
    }
    
    init(service: UserYearServiceProtocol) {
        self.initialState = State()
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .selectedYear(content: let year):
                return .just(.setSelectedYear(year))
            }
        }
        
        return Observable.merge(mutation, event)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapChoiceYearButton:
            return .concat([
                .just(.setPresentChoiceYearVC(true)),
                .just(.setIsSelectedYear(true)),
                .just(.setPresentChoiceYearVC(false))
            ])
        case .didTapChangeButton:
            
            guard let year = currentState.selectedYear else { return .empty() }
            
            return .concat([
                ChangeYearReactor.patchUserYear(year),
                .just(.setPopMyPage(false))
            ])
            
        case .didChangeSelectedYear(let year):
            return .concat([
                .just(.setSelectedYear(year)),
                .just(.setSelectedYear(nil))
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
        case .setIsSelectedYear(let isSelectedYear):
            state.isSelectedYear = isSelectedYear
        case .setSelectedYear(let year):
            state.selectedYear = year
        }
        
        return state
    }
}


extension ChangeYearReactor {
    
    func reactorForChoiceYear() -> ChoiceYearReactor {
        return ChoiceYearReactor(service: service)
    }
    
    static func patchUserYear(_ year: String) -> Observable<Mutation> {
        
        return MemberAPI.updateAge(params: ["age": 2024 - Int(year)!])
            .catch { _ in .empty() }
            .flatMap { response -> Observable<Mutation> in
                return .just(.setPopMyPage(true))
            }
    }
}
        
