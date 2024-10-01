//
//  HBTIQuantitySelectReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/20/24.
//

import RxSwift
import ReactorKit

final class HBTIQuantitySelectReactor: Reactor {
    enum Action {
        case didSelectQuantity(IndexPath)
        case didTapNextButton
    }
    
    enum Mutation {
        case setSeledtedIndex(Int)
        case setIsEnabledNextButton(Bool)
        case setIsPushNextVC(Bool)
        case setIsFreeSelection(Bool)
    }
    
    struct State {
        var selectedIndex: Int? = nil
        var isEnabledNextButton: Bool = false
        var isPushNextVC: Bool = false
        var isFreeSelection: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectQuantity(let indexPath):
            let isFreeSelection = (indexPath.row == 3)
            
            return .concat([
                .just(.setSeledtedIndex(indexPath.row)),
                .just(.setIsEnabledNextButton(true)),
                .just(.setIsFreeSelection(isFreeSelection))
            ])
            
        case .didTapNextButton:
            return currentState.isEnabledNextButton ? .just(.setIsPushNextVC(true)) : .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSeledtedIndex(let index):
            state.selectedIndex = index

        case .setIsEnabledNextButton(let isEnabled):
            state.isEnabledNextButton = isEnabled
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
            
        case .setIsFreeSelection(let isFree):
            state.isFreeSelection = isFree
        }
        
        return state
    }
}
