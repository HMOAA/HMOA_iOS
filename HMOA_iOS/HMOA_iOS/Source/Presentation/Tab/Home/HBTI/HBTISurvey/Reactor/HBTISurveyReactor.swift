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
        case didTapAnswerButton((HBTIQuestion, Int))
        case didChangePage(Int)
        case didTapNextButton
    }
    
    enum Mutation {
        case setQuestionList([HBTISurveyItem])
        case setCurrentPage(Int)
        case setSelectedIDList((HBTIQuestion, Int))
        case setNextPage(Int)
        case setIsEnabledNextButton
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var questionList: [HBTISurveyItem] = []
        var selectedIDList = [Int: [Int]]()
        var currentPage: Int? = nil
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
            
        case .didTapAnswerButton(let (question, answerID)):
            return .concat([
                .just(.setSelectedIDList((question, answerID))),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didChangePage(let page):
            return .concat([
                .just(.setCurrentPage(page)),
                .just(.setIsEnabledNextButton)
            ])
            
        case .didTapNextButton:
            guard let currentQuestionIndexPath = currentState.currentPage else {
                return .empty()
            }
            let questionCount = currentState.questionList.count
            let isLastQuestion = currentQuestionIndexPath == questionCount - 1
            let isAllSelected = currentState.selectedIDList.count == questionCount
            
            if isLastQuestion && isAllSelected {
                return .just(.setIsPushNextVC(true))
            }
                
            return .just(.setNextPage(currentQuestionIndexPath + 1))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setQuestionList(let items):
            state.questionList = items
            
        case .setCurrentPage(let row):
            print("setCurrentPage")
            state.currentPage = row
            
        case .setSelectedIDList(let (question, answerID)):
            let questionID = question.id
            
            guard let selectedID = state.selectedIDList[questionID] else {
                state.selectedIDList[questionID] = [answerID]
                break
            }
            
            if selectedID.contains(answerID) {
                if selectedID.count == 1 {
                    state.selectedIDList.removeValue(forKey: questionID)
                } else {
                    state.selectedIDList[questionID] = selectedID.filter { $0 != answerID }
                }
            } else {
                state.selectedIDList[questionID] = question.isMultipleChoice ? selectedID + [answerID] : [answerID]
            }
            
        case .setNextPage(let page):
            print("setNextPage")
            guard page < currentState.questionList.count else { break }
            state.currentPage = page
            
        case .setIsEnabledNextButton:
            print("setIsEnabledNextButton")
            guard let currentPage = state.currentPage else { break }
            let question = state.questionList[currentPage].question!
            
            state.isEnableNextButton = state.selectedIDList[question.id] != nil
            
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
                return .concat([
                    .just(.setQuestionList(listData)),
                    .just(.setCurrentPage(0))
                ])
            }
    }
}
