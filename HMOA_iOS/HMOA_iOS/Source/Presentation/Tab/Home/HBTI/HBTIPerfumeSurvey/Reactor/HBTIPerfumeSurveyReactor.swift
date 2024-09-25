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
        case viewDidLoad
        case didTapPriceButton(String)
        case isSelectedNoteItem(IndexPath)
        case isDeselectedNoteItem(IndexPath)
        case didTapCancelButton(String)
        case didTapClearButton
        case didTapNextButton
        case didChangePage(Int)
    }
    
    enum Mutation {
        case setQuestionList([HBTIPerfumeSurveyItem])
        case setSelectedPrice(String)
        case setSelectedNoteList((String, IndexPath), selcted: Bool)
        case clearSelectedNotes
        case setIsEnabledNextButton
        case setNextPage(Int)
        case setCurrentPage(Int)
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var questionList: [HBTIPerfumeSurveyItem] = []
        var noteList: [HBTINoteAnswer] = []
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
        case .viewDidLoad:
            return setSurvey()
            
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
        case .setQuestionList(let item):
            state.questionList = item
            state.noteList = item[1].note!.answer
            
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
    
    func setSurvey() -> Observable<Mutation> {
        return HBTIAPI.fetchPerfumeSurvey()
            .catch { _ in .empty() }
            .flatMap { surveyData -> Observable<Mutation> in
                let priceQuestion = HBTIPerfumeSurveyItem.price(surveyData.priceQuestion)
                let noteQuestion = HBTIPerfumeSurveyItem.note(surveyData.noteQuestion)
                
                return .concat([
                    .just(.setQuestionList([priceQuestion, noteQuestion]))
                ])
            }
    }
}
