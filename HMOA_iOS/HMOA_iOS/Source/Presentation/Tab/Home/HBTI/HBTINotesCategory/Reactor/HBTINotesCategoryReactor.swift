//
//  HBTINotesCategoryReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/27/24.
//

import RxSwift
import ReactorKit

final class HBTINotesCategoryReactor: Reactor {
    enum Action {
        case didTapNote(Int)
        case didTapNextButton
    }
    
    enum Mutation {
        case setSelectedNote([Int])
        case setIsEnabledNextButton(Bool)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        let recommendedNote: String
        var selectedNote: [Int] = []
        var isEnabledNextButton: Bool = false
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init(_ recommendedNote: String) {
        self.initialState = State(recommendedNote: recommendedNote)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNote(let id):
            var selectedNote = currentState.selectedNote
            
            if let index = selectedNote.firstIndex(of: id) {
                selectedNote.remove(at: index)
            } else if selectedNote.count < 8 {
                selectedNote.append(id)
            }
            
            let isEnabledNextButton = selectedNote.count > 0
            
            return .concat([
                .just(.setSelectedNote(selectedNote)),
                .just(.setIsEnabledNextButton(isEnabledNextButton))
            ])
            
        case .didTapNextButton:
            let isEnabled = currentState.isEnabledNextButton
            
            return .just(.setIsPushNextVC(isEnabled))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedNote(let selectedNotes):
            state.selectedNote = selectedNotes
            
        case .setIsEnabledNextButton(let isEnabled):
            state.isEnabledNextButton = isEnabled
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}
