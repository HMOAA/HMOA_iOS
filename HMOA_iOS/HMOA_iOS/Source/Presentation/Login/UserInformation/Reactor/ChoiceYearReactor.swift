//
//  ChoiceEmailReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/12.
//

import UIKit

import ReactorKit
import RxCocoa

class ChoiceYearReactor: Reactor {
    var initialState: State
    var service: UserYearServiceProtocol
    
    enum Action {
        case didTapOkButton
        case didTapXButton
        case didSelecteYear(Int)
    }
    
    enum Mutation {
        case setDismissStartVC(Bool)
        case setYearSelected(Int)
    }
    
    struct State {
        var isDismiss: Bool
        var selectedIndex: Int
    }
    
    init(service: UserYearServiceProtocol) {
        self.initialState = State(isDismiss: false, selectedIndex: 0)
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOkButton:
            return .concat([
                .just(.setDismissStartVC(true)),
                .just(.setDismissStartVC(false))
            ])
        case .didTapXButton:
            return .concat([
                .just(.setYearSelected(0)),
                .just(.setDismissStartVC(true)),
                .just(.setDismissStartVC(false))
            ])
        case .didSelecteYear(let index):
        
            let selectedYear = Year().year[index]
            return .concat([
                service.selectedYear(to: selectedYear).map { _ in .setYearSelected(index)}
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setDismissStartVC(let isDismiss):
            state.isDismiss = isDismiss
        case .setYearSelected(let index):
            state.selectedIndex = index
        }
        return state
    }
}
