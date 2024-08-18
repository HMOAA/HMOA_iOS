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
    }
    
    enum Mutation {
        case setSelectedID((Int, Int))
    }
    
    struct State {
        var selectedID = [Int: Int]()
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSelectedID(let (questionID, answerID)):
            if state.selectedID[questionID] == answerID {
                state.selectedID.removeValue(forKey: questionID)
            } else {
                state.selectedID[questionID] = answerID
            }
        }
        
        return state
    }
}
