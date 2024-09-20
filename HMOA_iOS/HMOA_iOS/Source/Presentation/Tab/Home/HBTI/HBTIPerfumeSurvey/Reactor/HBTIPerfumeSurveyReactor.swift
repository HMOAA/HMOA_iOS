//
//  HBTINoteReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/15/24.
//
import ReactorKit
import RxSwift

final class HBTIPerfumeSurveyReactor: Reactor {
    
    enum Action {
        case didTapPriceButton(String)
        case isSelectedNoteItem(IndexPath)
        case isDeselectedNoteItem(IndexPath)
        case didTapCancelButton(String)
        case didTapClearButton
        case didTapNextButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setSelectedPrice(String)
        case setSelectedNoteList((String, IndexPath), selcted: Bool)
        case clearSelectedNotes
        case setIsEnabledNextButton
        case setNextPage(Int)
        case setCurrentPage(Int)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var noteList: [HBTINoteAnswer] = [
            HBTINoteAnswer(category: "시험1", notes: ["노트1-1", "노트1-2"]),
            HBTINoteAnswer(category: "시험2", notes: ["노트2-1", "노트2-2"]),
            HBTINoteAnswer(category: "시험3", notes: ["노트3-1", "노트3-2"]),
            HBTINoteAnswer(category: "시험4", notes: ["노트4-1", "노트4-2"]),
            HBTINoteAnswer(category: "시험5", notes: ["노트5-1", "노트5-2"]),
            HBTINoteAnswer(category: "시험6", notes: ["노트6-1", "노트6-2"]),
            HBTINoteAnswer(category: "시험7", notes: ["노트7-1", "노트7-2"])
        ]
        var selectedPrice: String? = nil
        var selectedNoteList: [(String, IndexPath)] = []
        var isEnabledNextButton: Bool = false
        var currentPage: Int = 0
        var isPushNextVC = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapPriceButton(let price):
            return .concat([
                .just(.setSelectedPrice(price)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .isSelectedNoteItem(let indexPath):
            let note = findNoteName(from: currentState.noteList, by: indexPath)
            return .concat([
                .just(.setSelectedNoteList((note, indexPath), selcted: true)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .isDeselectedNoteItem(let indexPath):
            let note = findNoteName(from: currentState.noteList, by: indexPath)
            return .concat([
                .just(.setSelectedNoteList((note, indexPath), selcted: false)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didChangePage(let page):
            return .concat([
                .just(.setCurrentPage(page)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didTapCancelButton(let noteName):
            let noteList = currentState.selectedNoteList
            guard let index = noteList.firstIndex(where: { $0.0 == noteName }) else { return .empty() }
            
            return .just(.setSelectedNoteList(noteList[index], selcted: false))
            
        case .didTapClearButton:
            return .just(.clearSelectedNotes)
            
        case .didTapNextButton:
            if currentState.currentPage == 1 {
                return .just(.setIsPushNextVC(true))
            }
            return .just(.setNextPage(currentState.currentPage + 1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedPrice(let price):
            state.selectedPrice = state.selectedPrice == price ? nil : price
            
        case .setSelectedNoteList(let note, selcted: let selected):
            if selected {
                state.selectedNoteList.append(note)
            } else {
                let noteIndex = state.selectedNoteList.map { $0.0 }.firstIndex(of: note.0)!
                state.selectedNoteList.remove(at: noteIndex)
            }
            
        case .clearSelectedNotes:
            state.selectedNoteList = []
            
        case .setIsEnabledNextButton:
            if state.currentPage == 0 {
                state.isEnabledNextButton = state.selectedPrice != nil
            } else if state.currentPage == 1 {
                state.isEnabledNextButton = state.selectedPrice != nil && state.selectedNoteList.count > 0
            } else {
                state.isEnabledNextButton = false
            }
            
        case .setNextPage(let page):
            guard page < 2 else { break }
            state.currentPage = page
            
        case .setCurrentPage(let row):
            state.currentPage = row
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}

extension HBTIPerfumeSurveyReactor {
    func findNoteName(from noteList: [HBTINoteAnswer], by indexPath: IndexPath) -> String {
        return noteList[indexPath.section].notes[indexPath.row]
    }
}
