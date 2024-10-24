//
//  HBTIReviewListReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import ReactorKit
import RxSwift

final class HBTIReviewListReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case loadReviewListNextPage
        case didTapLikeButton(Int)
        case didTapFloatingButton
    }
    
    enum Mutation {
        case setReviewList([HBTIReviewListItem])
        case setIsLastPage(Bool)
        case setCurrentPage(Int)
        case setReviewLike(Int)
        case cancelReviewLike(Int)
        case setIsTapFloatingButton(Bool)
        case setNotReviewedOrderList([NotReviewedOrder])
    }
    
    struct State {
        let isLog: Bool
        var reviewList: [HBTIReviewListItem] = []
        var currentPage: Int = -1
        var isLastPage: Bool = false
        var isFloatingButtonTap: Bool = false
        var notReviewedOrderList: [NotReviewedOrder] = [
            NotReviewedOrder(id: 11, info: "후기 작성하기 (시트러스 24.10.08)"),
            NotReviewedOrder(id: 33, info: "후기 작성하기 (플로럴 24.10.08)")
        ]
    }
    
    var initialState: State
    
    init(isLog: Bool) {
        self.initialState = State(isLog: isLog)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                setReviewList()
                // TODO: 주문 추가 가능해지면 사용
//                setNotReviewedOrderList()
            ])
            
        case .loadReviewListNextPage:
            return setReviewList()
            
        case .didTapLikeButton(let index):
            return setReviewLike(index: index)
            
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setReviewList(let item):
            state.reviewList += item
            
        case .setIsLastPage(let isLast):
            state.isLastPage = isLast
            
        case .setCurrentPage(let page):
            state.currentPage = page
            
        case .setReviewLike(let index):
            guard var review = state.reviewList[index].review else { break }
            review.isLiked = true
            review.likeCount += 1
            state.reviewList[index] = HBTIReviewListItem.review(review)
        
        case .cancelReviewLike(let index):
            guard var review = state.reviewList[index].review else { break }
            review.isLiked = false
            review.likeCount -= 1
            state.reviewList[index] = HBTIReviewListItem.review(review)
            
        case .setIsTapFloatingButton(let isTap):
            state.isFloatingButtonTap = isTap
            
        case .setNotReviewedOrderList(let item):
            state.notReviewedOrderList = item
        }
        
        return state
    }
}

extension HBTIReviewListReactor {
    func setReviewList() -> Observable<Mutation> {
        guard !currentState.isLastPage else { return .empty() }
        
        let nextPage = currentState.currentPage + 1
        
        return HBTIAPI.fetchReivewList(page: nextPage)
            .catch { _ in .empty() }
            .flatMap { reviewListData -> Observable<Mutation> in
                let listData = reviewListData.data.map { review in
                    return HBTIReviewListItem.review(review)
                }
                let isLastPage = reviewListData.isLastPage
                
                return .concat([
                    .just(.setReviewList(listData)),
                    .just(.setIsLastPage(isLastPage)),
                    .just(.setCurrentPage(nextPage))
                ])
            }
    }
    
    func setReviewLike(index: Int) -> Observable<Mutation> {
        guard let review = currentState.reviewList[index].review else { return .empty() }
        
        if !review.isLiked {
            return HBTIAPI.putReviewLike(id: review.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .concat([
                        .just(.setReviewLike(index))
                    ])
                }
        } else {
            return HBTIAPI.deleteReviewLike(id: review.id)
                .catch { _ in .empty() }
                .flatMap { _ -> Observable<Mutation> in
                    return .concat([
                        .just(.cancelReviewLike(index))
                    ])
                }
        }
    }
    
    func setNotReviewedOrderList() -> Observable<Mutation> {
        return HBTIAPI.fetchNotReviewdOrderList()
            .catch { _ in .empty() }
            .flatMap { orderListData -> Observable<Mutation> in
                return .just(.setNotReviewedOrderList(orderListData))
            }
    }
}
