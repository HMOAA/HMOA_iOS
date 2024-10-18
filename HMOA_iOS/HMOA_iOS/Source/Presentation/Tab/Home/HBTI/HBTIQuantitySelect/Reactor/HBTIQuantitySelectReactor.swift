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
        case viewDidLoad
        case didSelectQuantity(IndexPath)
        case didTapNextButton
    }
    
    enum Mutation {
        case setNoteName(String)
        case setSeledtedIndex(Int)
        case setIsEnabledNextButton(Bool)
        case setIsPushNextVC(Bool)
        case setIsFreeSelection(Bool)
    }
    
    struct State {
        var noteName: String = ""
        var selectedIndex: Int? = nil
        var isEnabledNextButton: Bool = false
        var isPushNextVC: Bool = false
        var isFreeSelection: Bool = false
        var recommendNote: [String: Any]
    }
    
    var initialState: State
    
    init(_ recommendNote: [String: Any]) {
        self.initialState = State(recommendNote: recommendNote)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let noteName = currentState.recommendNote["name"] as? String ?? "Unknown Note"
            return .just(.setNoteName(noteName))
            
        case .didSelectQuantity(let indexPath):
            let isFreeSelection = (indexPath.row == 3)
            
            return .concat([
                .just(.setSeledtedIndex(indexPath.row)),
                .just(.setIsEnabledNextButton(true)),
                .just(.setIsFreeSelection(isFreeSelection))
            ])
            
        case .didTapNextButton:
            let isEnabled = currentState.isEnabledNextButton
            
            return .just(.setIsPushNextVC(isEnabled))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNoteName(let noteName):
            state.noteName = noteName
            
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
