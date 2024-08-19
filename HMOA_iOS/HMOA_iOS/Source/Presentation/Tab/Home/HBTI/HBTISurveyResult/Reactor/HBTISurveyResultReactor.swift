//
//  HBTISurveyResultReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//
import ReactorKit
import RxSwift

final class HBTISurveyResultReactor: Reactor {
    
    enum Action {
        case isTapNextButton
    }
    
    enum Mutation {
        case setIsPushNextVC
    }
    
    struct State {
        var noteItems: [HBTISurveyResultItem] = [.recommand(HBTISurveyResultNote(id: 999, name: "시험용", photoURL: "시험용", content: "시험용"))]
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .isTapNextButton:
            return .just(.setIsPushNextVC)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPushNextVC:
            state.isPushNextVC = true
        }
        
        return state
    }
}
