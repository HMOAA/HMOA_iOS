//
//  OrderLogReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/23/24.
//

import ReactorKit
import RxSwift

final class OrderLogReactor: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case setOrderList([OrderLogItem])
    }
    
    struct State {
        var orderList: [OrderLogItem] = []
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setOrderList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setOrderList(let order):
            print(order)
            state.orderList = order
        }
        
        return state
    }
}

extension OrderLogReactor {
    func setOrderList() -> Observable<Mutation> {
        return MemberAPI.fetchOrderList(["cursor": 0])
            .catch { _ in .empty() }
            .flatMap { OrderResponseData -> Observable<Mutation> in
                let orderItemList = OrderResponseData.orders.map { order in
                    return OrderLogItem.order(order)
                }
                return .just(.setOrderList(orderItemList))
            }
    }
}
