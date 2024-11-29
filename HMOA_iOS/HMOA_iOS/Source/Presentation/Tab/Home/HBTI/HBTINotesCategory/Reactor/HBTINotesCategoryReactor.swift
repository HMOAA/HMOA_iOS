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
        case viewDidLoad
        case didTapNote(Int)
        case didTapNextButton
    }
    
    enum Mutation {
        case setNoteList([HBTINotesCategoryItem])
        case setPricePerNote(Int)
        case setSelectedNote([Int])
        case setIsEnabledNextButton(Bool)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        let recommendedNote: String
        var noteList: [HBTINotesCategoryItem] = []
        var pricePerNote: Int = 0
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
        case .viewDidLoad:
            return setNoteList()
            
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
            
            return .concat([
                .just(.setIsPushNextVC(isEnabled)),
                .just(.setIsPushNextVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNoteList(let noteList):
            state.noteList = noteList
            
        case .setPricePerNote(let pricePerNote):
            state.pricePerNote = pricePerNote
            
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

extension HBTINotesCategoryReactor {
    func setNoteList() -> Observable<Mutation> {
        return HBTIAPI.fetchNoteList()
            .catch { _ in .empty() }
            .flatMap { noteListData -> Observable<Mutation> in
                let noteItems = noteListData.noteList.map { note in
                    return HBTINotesCategoryItem.note(note)
                }
                let pricePerNote = noteListData.noteList[0].price / (noteListData.noteList[0].noteComposition.filter { $0 == "," }.count + 1)
                
                return .concat([
                    .just(.setNoteList(noteItems)),
                    .just(.setPricePerNote(pricePerNote))
                ])
            }
    }
}
