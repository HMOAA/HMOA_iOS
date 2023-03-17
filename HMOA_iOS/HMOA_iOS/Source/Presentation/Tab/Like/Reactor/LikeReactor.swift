//
//  LikeReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import UIKit
import ReactorKit

class LikeReactor: Reactor {
    
    let initialState: State
    
    init() {
        initialState = State(sections: [CardSection(items: CardData.items)])
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [CardSection]
    }
    
//    func mutate(action: Action) -> Observable<Mutation> {
//        <#code#>
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        <#code#>
//    }
}
