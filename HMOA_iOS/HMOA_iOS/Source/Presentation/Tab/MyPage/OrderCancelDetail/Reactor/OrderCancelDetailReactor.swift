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
        case viewDidLoad
        case didTapRequestButton
    }
    
    enum Mutation {
        case setOrder(OrderLogItem)
        case setIsNextVC(Bool)
    }
    
    struct State {
        var order: OrderLogItem
        var requestKind: OrderCancelRequestKind
        var isPushNextVC: Bool = false
    }
    
    var initialState: State
    
    init(_ order: OrderLogItem, _ orderCancelRequest: OrderCancelRequestKind) {
        self.initialState = State(order: order, requestKind: orderCancelRequest)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.setOrder(currentState.order))
            
        case .didTapRequestButton:
            return .concat([
                .just(.setIsNextVC(true)),
                .just(.setIsNextVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setOrder(let order):
            state.order = order
            
        case .setIsNextVC(let isPush):
            state.isPushNextVC = isPush
        }
        
        return state
    }
}
