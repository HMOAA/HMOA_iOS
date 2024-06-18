//
//  NotificationReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/17/24.
//

import Foundation
import ReactorKit
import RxSwift

class PushAlarmReactor: Reactor {
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
    }
    
    init() {
        initialState = State()
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
