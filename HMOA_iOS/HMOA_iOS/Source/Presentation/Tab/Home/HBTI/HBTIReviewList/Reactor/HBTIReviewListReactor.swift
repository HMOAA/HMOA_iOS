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
    }
    
    enum Mutation {
        case setReviewList([HBTIReviewListItem])
    }
    
    struct State {
        let isLog: Bool
        var reviewList: [HBTIReviewListItem] = []
    }
    
    var initialState: State
    
    init(isLog: Bool) {
        self.initialState = State(isLog: isLog)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return setReviewList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setReviewList(let item):
            state.reviewList = item
        }
        
        return state
    }
}

extension HBTIReviewListReactor {
    func setReviewList() -> Observable<Mutation> {
        return HBTIAPI.fetchReivewList(page: 0)
            .catch { _ in .empty() }
            .flatMap { reviewListData -> Observable<Mutation> in
                let listData = reviewListData.data.map { review in
                    return HBTIReviewListItem.review(review)
                }
                
                return .concat([
                    .just(.setReviewList(listData))
                ])
            }
    }
}
