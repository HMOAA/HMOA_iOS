//
//  MagazineReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2/22/24.
//

import Foundation

import ReactorKit
import RxSwift

class MagazineReactor: Reactor {
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
