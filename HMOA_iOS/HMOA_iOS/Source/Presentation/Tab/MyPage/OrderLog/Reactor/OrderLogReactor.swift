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
        case didTapRefundButton(OrderLogItem)
        case didTapReturnButton(OrderLogItem)
        case didTapReviewButton
    }
    
    enum Mutation {
        case setOrderList([OrderLogItem])
        case setNextPage(Int)
        case setSelectedOrder(OrderLogItem?)
        case setIsPushRefundVC(Bool)
        case setIsPushReturnVC(Bool)
        case setIsPushReviewVC(Bool)
    }
    
    struct State {
        var orderList: [OrderLogItem] = OrderLogItem.exampleOrder
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
        case .viewDidLoad:
            return setOrderList()
            
        case .loadNextPage:
            return setOrderList()
            
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
            
        case .didTapReviewButton:
            return .concat([
                .just(.setIsPushReviewVC(true)),
                .just(.setIsPushReviewVC(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setOrderList(let order):
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
