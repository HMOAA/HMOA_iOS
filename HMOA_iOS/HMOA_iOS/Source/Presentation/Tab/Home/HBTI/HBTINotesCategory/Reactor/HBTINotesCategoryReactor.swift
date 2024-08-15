//
//  HBTINotesCategoryReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 7/30/24.
//

import RxSwift
import ReactorKit

class HBTINotesCategoryReactor: Reactor {
    enum Action {
        case didTapNextButton
        case selectNote(Int)
    }
    
    enum Mutation {
        case setIsPushNextVC(Bool)
        case updateSelectedNotes([Int])
        case setNextButtonEnabled(Bool)
    }
    
    struct State {
        var isPushNextVC: Bool = false
        var selectedNotes: [Int] = []
        var isNextButtonEnabled: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPushNextVC(true))
            
        case .selectNote(let index):
            var newSelectedNotes = currentState.selectedNotes
            
            if let existingIndex = newSelectedNotes.firstIndex(of: index) {
                newSelectedNotes.remove(at: existingIndex)
            } else {
                newSelectedNotes.append(index)
            }
            
            return .concat([
                .just(.updateSelectedNotes(newSelectedNotes)),
                .just(.setNextButtonEnabled(!newSelectedNotes.isEmpty))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        case .updateSelectedNotes(let notes):
            state.selectedNotes = notes
        case .setNextButtonEnabled(let isEnabled):
            state.isNextButtonEnabled = isEnabled
        }
        return state
    }
}
