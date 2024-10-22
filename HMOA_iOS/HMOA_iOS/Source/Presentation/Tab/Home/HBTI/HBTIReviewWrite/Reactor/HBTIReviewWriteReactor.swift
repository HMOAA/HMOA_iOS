//
//  HBTIReviewWriteReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/21/24.
//
import ReactorKit
import RxSwift

final class HBTIReviewWriteReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
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
