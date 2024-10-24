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
    }
    
    enum Mutation {
        case setReviewList([HBTIReviewListItem])
        case setIsLastPage(Bool)
        case setCurrentPage(Int)
    }
    
    struct State {
        let isLog: Bool
        var reviewList: [HBTIReviewListItem] = []
        var currentPage: Int = -1
        var isLastPage: Bool = false
    }
    
    var initialState: State
    
    init(isLog: Bool) {
        self.initialState = State(isLog: isLog)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setReviewList()
            
        case .loadReviewListNextPage:
            return setReviewList()
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
}
