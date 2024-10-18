//
//  HBTIProcessGuideReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import RxSwift
import ReactorKit

final class HBTIProcessGuideReactor: Reactor {
    enum Action {
        case didTapNextButton
    }
    
    enum Mutation {
        case setIsPushNextVC(Bool)
    }
    
    struct State {
        var isPushNextVC: Bool = false
        var recommendNoteList: [HBTISurveyResultItem]
    }
    
    var initialState: State
    
    init(_ recommendNoteList: [HBTISurveyResultItem]) {
        self.initialState = State(recommendNoteList: recommendNoteList)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPushNextVC(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIsPushNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        return state
    }
}
