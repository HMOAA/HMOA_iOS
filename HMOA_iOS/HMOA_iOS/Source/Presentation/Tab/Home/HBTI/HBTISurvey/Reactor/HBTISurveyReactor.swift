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
        case viewDidLoad
        case didTapAnswerButton((Int, Int))
        case didChangeQuestion(Int)
        case didTapNextButton
    }
    
    enum Mutation {
        case setQuestionList([HBTISurveyItem])
        case setCurrentQuestion(Int)
        case setSelectedID((Int, Int))
        case setNextQuestion(Int)
        case setIsEnabledNextButton
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var questionList: [HBTISurveyItem] = []
        var selectedID = [Int: Int]()
        var currentQuestion: Int? = nil
        var isEnableNextButton: Bool = false
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setQuestionList()
            
        case .didTapAnswerButton(let (questionID, answerID)):
            return .concat([
                .just(.setSelectedID((questionID, answerID))),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didChangeQuestion(let row):
            return .concat([
                .just(.setCurrentQuestion(row)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didTapNextButton:
            guard let currentQuestionIndexPath = currentState.currentQuestion else {
                return .empty()
            }
            // TODO: API 연동 후 조건문 변경
            if currentQuestionIndexPath == 4 - 1 && currentState.selectedID.count == 4 {
                return .just(.setIsPushNextVC(true))
            }
                
            return .just(.setNextQuestion(currentQuestionIndexPath + 1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setQuestionList(let items):
            state.questionList = items
            
        case .setCurrentQuestion(let row):
            state.currentQuestion = row
            
        case .setSelectedID(let (questionID, answerID)):
            if state.selectedID[questionID] == answerID {
                state.selectedID.removeValue(forKey: questionID)
            } else {
                state.selectedID[questionID] = answerID
            }
            
        case .setNextQuestion(let row):
            // TODO: API 연동 후 조건문 변경
            guard row < 4 else { return state }
            state.currentQuestion = row
            
        case .setIsEnabledNextButton:
            guard let currentPage = state.currentQuestion else { return state }
            state.isEnableNextButton = currentPage <= state.selectedID.count - 1
            
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}

extension HBTISurveyReactor {
    func setQuestionList() -> Observable<Mutation> {
        return HBTIAPI.fetchSurvey()
            .catch { _ in .empty() }
            .flatMap { questionListData -> Observable<Mutation> in
                let listData = questionListData.questions.map { questionData in
                    
                    
                    return HBTISurveyItem.question(
                        HBTIQuestion(
                            id: questionData.id,
                            content: questionData.content,
                            answers: questionData.answers,
                            isMultipleChoice: questionData.isMultipleChoice
                        )
                    )
                }
                print(listData)
                return .just(.setQuestionList(listData))
            }
    }
}
