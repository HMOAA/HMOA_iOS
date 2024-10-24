//
//  HBTIReviewListReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import ReactorKit
import RxSwift

final class HBTIReviewListReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let isLog: Bool
    }
    
    var initialState: State
    
    init(isLog: Bool) {
        self.initialState = State(isLog: isLog)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        }
        
        return state
    }
}
