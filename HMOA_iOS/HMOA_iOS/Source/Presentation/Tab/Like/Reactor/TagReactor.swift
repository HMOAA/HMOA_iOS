//
//  TagReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import UIKit
import ReactorKit

class TagReactor: Reactor {
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [String] = ["우디한", "자연의"]
    }
    
//    func mutate(action: Action) -> Observable<Mutation> {
//        <#code#>
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        <#code#>
//    }
}
