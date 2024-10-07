//
//  OrderCancelDetailReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/26/24.
//

import Foundation

import ReactorKit
import RxSwift

final class OrderCancelDetailReactor: Reactor {
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var requestKind: OrderCancelRequestKind
    }
    
    var initialState: State
    
    init(_ orderCancelRequest: OrderCancelRequestKind) {
        self.initialState = State(requestKind: orderCancelRequest)
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
