//
//  OrderCancelLogReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import ReactorKit
import RxSwift

final class OrderCancelLogReactor: Reactor {

    enum Action {
        case viewDidLoad
        case loadNextPage
    }

    enum Mutation {
        case setOrderCancelList([OrderCancelLogItem])
        case setNextPage(Int)
    }

    struct State {
        var orderCancelList: [OrderCancelLogItem] = []
        var nextPage: Int = 0
    }

    var initialState: State

    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setOrderCancelList()
            
        case .loadNextPage:
            return setOrderCancelList()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setOrderCancelList(let list):
            state.orderCancelList += list
            
        case .setNextPage(let page):
            state.nextPage = page
        }

        return state
    }
}

extension OrderCancelLogReactor {
    func setOrderCancelList() -> Observable<Mutation> {
        let page = currentState.nextPage
        let query: [String: Int] = ["cursor": page]
        
        return MemberAPI.fetchOrderCancelList(query)
            .catch { _ in .empty() }
            .flatMap { OrderResponseData -> Observable<Mutation> in
                let orderItemList = OrderResponseData.orders.map { order in
                    return OrderCancelLogItem.order(order)
                }
                return .concat([
                    .just(.setOrderCancelList(orderItemList)),
                    .just(.setNextPage(page + 1))
                ])
            }
    }
}
