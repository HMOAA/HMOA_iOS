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
    }

    enum Mutation {
        case setOrderCancelList([OrderCancelLogItem])
    }

    struct State {
        var orderCancelList: [OrderCancelLogItem] = []
    }

    var initialState: State

    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setOrderCancelList()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setOrderCancelList(let list):
            state.orderCancelList = list
        }

        return state
    }
}

extension OrderCancelLogReactor {
    func setOrderCancelList() -> Observable<Mutation> {
        let query: [String: Int] = ["cursor": 0]
        
        return MemberAPI.fetchOrderCancelList(query)
            .catch { _ in .empty() }
            .flatMap { OrderResponseData -> Observable<Mutation> in
                let orderItemList = OrderResponseData.orders.map { order in
                    return OrderCancelLogItem.order(order)
                }
                return .concat([
                    .just(.setOrderCancelList(orderItemList))
                ])
            }
    }
}
