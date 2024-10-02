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
        case loadNextPage
    }
    
    enum Mutation {
        case setOrderList([OrderLogItem])
        case setNextPage(Int)
    }
    
    struct State {
        var orderList: [OrderLogItem] = OrderLogItem.exampleOrder
        var nextPage: Int = 0
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setOrderList()
        case .loadNextPage:
            return setOrderList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setOrderList(let order):
            state.orderList += order
            
        case .setNextPage(let page):
            state.nextPage = page
        }
        
        return state
    }
}

extension OrderLogReactor {
    func setOrderList() -> Observable<Mutation> {
        let page = currentState.nextPage
        let query: [String: Int] = ["cursor": page]
        
        return MemberAPI.fetchOrderList(query)
            .catch { _ in .empty() }
            .flatMap { OrderResponseData -> Observable<Mutation> in
                let orderItemList = OrderResponseData.orders.map { order in
                    return OrderLogItem.order(order)
                }
                return .concat([
                    .just(.setOrderList(orderItemList)),
                    .just(.setNextPage(page + 1))
                ])
            }
    }
}
