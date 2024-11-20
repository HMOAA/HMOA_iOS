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
        case viewWillAppear
        case viewDidDisappear
        case loadNextPage
        case didTapRefundButton(OrderLogItem)
        case didTapReturnButton(OrderLogItem)
        case didTapReviewButton(OrderLogItem)
    }
    
    enum Mutation {
        case setOrderList([OrderLogItem])
        case appendOrderList([OrderLogItem])
        case setNextPage(Int)
        case setSelectedOrder(OrderLogItem?)
        case setIsPushRefundVC(Bool)
        case setIsPushReturnVC(Bool)
        case setIsPushReviewVC(Bool)
    }
    
    struct State {
        var orderList: [OrderLogItem] = []
        var nextPage: Int = 0
        var selectedOrder: OrderLogItem? = nil
        var isPushRefundVC: Bool = false
        var isPushReturnVC: Bool = false
        var isPushReviewVC: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return setOrderList()
            
        case .viewDidDisappear:
            return .concat([
                .just(.setNextPage(0)),
                .just(.setOrderList([]))
            ])
            
        case .loadNextPage:
            return appendOrderList()
            
        case .didTapRefundButton(let order):
            return .concat([
                .just(.setSelectedOrder(order)),
                .just(.setIsPushRefundVC(true)),
                .just(.setSelectedOrder(nil)),
                .just(.setIsPushRefundVC(false))
            ])
            
        case .didTapReturnButton(let order):
            return .concat([
                .just(.setSelectedOrder(order)),
                .just(.setIsPushReturnVC(true)),
                .just(.setSelectedOrder(nil)),
                .just(.setIsPushReturnVC(false))
            ])
            
        case .didTapReviewButton(let order):
            return .concat([
                .just(.setSelectedOrder(order)),
                .just(.setIsPushReviewVC(true)),
                .just(.setSelectedOrder(nil)),
                .just(.setIsPushReviewVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setOrderList(let order):
            state.orderList = order
            
        case .appendOrderList(let order):
            state.orderList += order
            
        case .setNextPage(let page):
            state.nextPage = page
            
        case .setSelectedOrder(let order):
            state.selectedOrder = order
            
        case .setIsPushRefundVC(let isPush):
            state.isPushRefundVC = isPush
            
        case .setIsPushReturnVC(let isPush):
            state.isPushReturnVC = isPush
            
        case .setIsPushReviewVC(let isPush):
            state.isPushReviewVC = isPush
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
                return .concat([
                    .just(.setOrderList(orderItemList)),
                    .just(.setNextPage(1))
                ])
            }
    }
    
    func appendOrderList() -> Observable<Mutation> {
        let page = currentState.nextPage
        let query: [String: Int] = ["cursor": page]
        
        return MemberAPI.fetchOrderList(query)
            .catch { _ in .empty() }
            .flatMap { OrderResponseData -> Observable<Mutation> in
                let orderItemList = OrderResponseData.orders.map { order in
                    return OrderLogItem.order(order)
                }
                return .concat([
                    .just(.appendOrderList(orderItemList)),
                    .just(.setNextPage(page + 1))
                ])
            }
    }
}
