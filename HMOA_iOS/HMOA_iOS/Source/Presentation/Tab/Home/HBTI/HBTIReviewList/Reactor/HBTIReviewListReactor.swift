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
        case viewWillAppear
        case viewDidAppear
        case loadReviewListNextPage
        case didTapLikeButton(Int)
        case didTapFloatingButton
        case didTapFloatingBackView
        case didTapWriteReviewButton(Int)
        case didTapOptionButton(HBTIReview?)
        case didTapDeleteReview
        case didTapEditReview
    }
    
    enum Mutation {
        case setReviewList([HBTIReviewListItem])
        case appendReviewList([HBTIReviewListItem])
        case setIsLastPage(Bool)
        case setCurrentPage(Int)
        case setReviewLike(Int)
        case cancelReviewLike(Int)
        case setIsTapFloatingButton(Bool)
        case setNotReviewedOrderList([NotReviewedOrder])
        case setSelectedOrderID(Int?)
        case setIsPushReviewWriteVC(Bool)
        case setSelectedReview(HBTIReview?)
        case setIsEditReview(Bool)
    }
    
    struct State {
        let isLog: Bool
        var reviewList: [HBTIReviewListItem] = []
        var currentPage: Int = -1
        var isLastPage: Bool = false
        var isFloatingButtonTap: Bool = false
        var notReviewedOrderList: [NotReviewedOrder] = []
        var selectedOrderID: Int? = nil
        var isPushReviewWriteVC: Bool = false
        var selectedReview: HBTIReview? = nil
        var isEditReivew: Bool = false
    }
    
    var initialState: State
    
    init(isLog: Bool) {
        self.initialState = State(isLog: isLog)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                .just(.setCurrentPage(-1)),
                .just(.setIsLastPage(false))
            ])
            
        case .viewDidAppear:
            return .concat([
                setReviewList(),
                setNotReviewedOrderList()
            ])
            
        case .loadReviewListNextPage:
            return setReviewList()
            
        case .didTapLikeButton(let index):
            return setReviewLike(index: index)
            
        case .didTapFloatingButton:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            
        case .didTapFloatingBackView:
            return .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap))
            
        case .didTapWriteReviewButton(let id):
            return .concat([
                .just(.setIsTapFloatingButton(!currentState.isFloatingButtonTap)),
                .just(.setSelectedOrderID(id)),
                .just(.setIsPushReviewWriteVC(true)),
                .just(.setSelectedOrderID(nil))
            ])
            
        case .didTapOptionButton(let review):
            return .concat([
                .just(.setSelectedReview(review))
            ])
            
        case .didTapDeleteReview:
            return .concat([
                deleteSelectedReview(),
                .just(.setSelectedReview(nil)),
                setNotReviewedOrderList()
            ])
            
        case .didTapEditReview:
            return .concat([
                .just(.setIsEditReview(true)),
                .just(.setIsEditReview(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setReviewList(let item):
            state.reviewList = item
            
        case .appendReviewList(let item):
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
            
        case .setSelectedOrderID(let id):
            state.selectedOrderID = id
            
        case .setIsPushReviewWriteVC(let isPush):
            state.isPushReviewWriteVC = isPush
            
        case .setSelectedReview(let review):
            state.selectedReview = review
            
        case .setIsEditReview(let isEdit):
            state.isEditReivew = isEdit
        }
        
        return state
    }
}

extension HBTIReviewListReactor {
    func setReviewList() -> Observable<Mutation> {
        guard !currentState.isLastPage else { return .empty() }
        
        let nextPage = currentState.currentPage + 1
        
        return HBTIAPI.fetchReivewList(fromMember: currentState.isLog, page: nextPage)
            .catch { _ in .empty() }
            .flatMap { reviewListData -> Observable<Mutation> in
                let listData = reviewListData.data.map { review in
                    return HBTIReviewListItem.review(review)
                }
                let isLastPage = reviewListData.isLastPage
                
                if self.currentState.isPushReviewWriteVC || !self.currentState.isLastPage {
                    return .concat([
                        .just(.setIsPushReviewWriteVC(false)),
                        .just(.setReviewList(listData)),
                        .just(.setIsLastPage(isLastPage)),
                        .just(.setCurrentPage(nextPage))
                    ])
                } else {
                    return .concat([
                        .just(.appendReviewList(listData)),
                        .just(.setIsLastPage(isLastPage)),
                        .just(.setCurrentPage(nextPage))
                    ])
                }
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
    
    func deleteSelectedReview() -> Observable<Mutation> {
        guard let review = currentState.selectedReview else { return .empty() }
        var reviewList = currentState.reviewList
        let index = reviewList.firstIndex(of: .review(review))!
        reviewList.remove(at: index)
        
        return HBTIAPI.deleteReivew(id: review.id)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                return .just(.setReviewList(reviewList))
            }
    }
}
