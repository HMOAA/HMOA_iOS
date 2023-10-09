//
//  CommentReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import RxSwift
import ReactorKit

final class CommentReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapOptionButton
    }
    
    enum Mutation {
        case setIsPresentOptionVC(Bool)
    }
    
    struct State {
        var options: [String]
        var isPresentOptionVC: Bool = false
    }
    
    init(_ options: [String]) {
        initialState = State(options: options)
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapOptionButton:
            return .concat([
                .just(.setIsPresentOptionVC(true)),
                .just(.setIsPresentOptionVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setIsPresentOptionVC(let isPresent):
            state.isPresentOptionVC = isPresent
        }
        
        return state
    }
    
    
}
