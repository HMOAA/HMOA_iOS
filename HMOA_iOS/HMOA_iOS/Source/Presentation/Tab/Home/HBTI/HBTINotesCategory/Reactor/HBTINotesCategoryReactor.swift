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
//        case didTapNextButton
    }
    
    enum Mutation {
        case setUpdateNoteList([Int])
    }
    
    struct State {
        var selectedQuantity: Int
        var selectedNote: [Int] = []
    }
    
    var initialState: State
    
    init(_ selectedQuantity: Int) {
        self.initialState = State(selectedQuantity: selectedQuantity)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNote(let id):
            var selectedNote = currentState.selectedNote
            
            if let index = selectedNote.firstIndex(of: id) {
                selectedNote.remove(at: index)
            }
            else if selectedNote.count < currentState.selectedQuantity {
                selectedNote.append(id)
            }
            
            return .just(.setUpdateNoteList(selectedNote))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setUpdateNoteList(let selectedNotes):
            state.selectedNote = selectedNotes
        }
        
        return state
    }
}
