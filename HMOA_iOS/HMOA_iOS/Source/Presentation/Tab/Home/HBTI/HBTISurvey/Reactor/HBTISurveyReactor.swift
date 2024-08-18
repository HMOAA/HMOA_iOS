//
//  HBTISurveyReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/12/24.
//

import ReactorKit
import RxSwift

final class HBTISurveyReactor: Reactor {
    
    enum Action {
        case didTapAnswerButton((Int, Int))
        case didChangeQuestion(Int)
        case didTapNextButton
    }
    
    enum Mutation {
        case setCurrentQuestion(Int)
        case setSelectedID((Int, Int))
        case setNextQuestion(Int)
    }
    
    struct State {
        var selectedID = [Int: Int]()
        var currentQuestion: Int? = nil
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAnswerButton(let (questionID, answerID)):
            return .concat([
                .just(.setSelectedID((questionID, answerID)))
            ])
            
        case .didChangeQuestion(let row):
            return .just(.setCurrentQuestion(row))
            
        case .didTapNextButton:
            guard let currentQuestionIndexPath = currentState.currentQuestion else {
                return .empty()
            }
            return .just(.setNextQuestion(currentQuestionIndexPath + 1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setCurrentQuestion(let row):
            state.currentQuestion = row
            
        case .setSelectedID(let (questionID, answerID)):
            if state.selectedID[questionID] == answerID {
                state.selectedID.removeValue(forKey: questionID)
            } else {
                state.selectedID[questionID] = answerID
            }
            state.selectedID[questionID] = answerID
            
        case .setNextQuestion(let row):
            // TODO: API 연동 후 조건문 변경
            guard row < 4 else { return state }
            state.currentQuestion = row
        }
        
        return state
    }
}
