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
        case didTapNextButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setSelectedPrice(String)
        case setSelectedNoteList(String, selcted: Bool)
        case setIsEnabledNextButton
        case setNextPage(Int)
        case setCurrentPage(Int)
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
        var selectedNoteList: [String] = []
        var isEnabledNextButton: Bool = false
        var currentPage: Int = 0
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
            let note = findNote(of: currentState.noteList, from: indexPath)
            return .just(.setSelectedNoteList(note, selcted: true))
            
        case .isDeselectedNoteItem(let indexPath):
            let note = findNote(of: currentState.noteList, from: indexPath)
            return .just(.setSelectedNoteList(note, selcted: false))
            
        case .didChangePage(let page):
            return .concat([
                .just(.setCurrentPage(page)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didTapNextButton:
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
                let noteIndex = state.selectedNoteList.firstIndex(of: note)!
                state.selectedNoteList.remove(at: noteIndex)
            }
            
        case .setIsEnabledNextButton:
            if state.currentPage == 0 {
                state.isEnabledNextButton = state.selectedPrice != nil
            } else {
                // TODO: 향료 state에 따라 업데이트
                state.isEnabledNextButton = false
            }
            
        case .setNextPage(let page):
            guard page < 2 else { break }
            state.currentPage = page
            
        case .setCurrentPage(let row):
            state.currentPage = row
        }
        
        return state
    }
}

extension HBTIPerfumeSurveyReactor {
    func findNote(of noteList: [HBTINoteAnswer], from indexPath: IndexPath) -> String {
        return noteList[indexPath.section].notes[indexPath.row]
    }
}
