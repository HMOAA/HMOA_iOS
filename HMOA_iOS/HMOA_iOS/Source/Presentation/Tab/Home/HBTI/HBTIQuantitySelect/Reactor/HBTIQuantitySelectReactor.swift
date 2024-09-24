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
        case setSelectedQuantity(IndexPath)
        case setIsEnabledNextButton(Bool)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var selectedQuantity: Int? = nil
        var isEnabledNextButton: Bool = false
        var isPushNextVC: Bool = false
        var selectedIndex: IndexPath?
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didSelectQuantity(let indexPath):
            return .concat([
                .just(.setSelectedQuantity(indexPath)),
                .just(.setIsEnabledNextButton(true))
            ])
            
        case .didTapNextButton:
            if currentState.selectedQuantity != nil {
                return .just(.setIsPushNextVC(true))
            }
            
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedQuantity(let indexPath):
            state.selectedQuantity = indexPath.row
            state.selectedIndex = indexPath

        case .setIsEnabledNextButton(let isEnabled):
            state.isEnabledNextButton = isEnabled
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}

