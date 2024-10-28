//
//  HBTIReactor.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//
import ReactorKit
import RxSwift

final class HBTIReactor: Reactor {
    
    enum Action {
        case viewWillAppear
        case didTapSurveyCell(Int)
        case didTapSeeAllReviewButton
        case didTapLikeButton(Int)
    }
    
    enum Mutation {
        case setTopReviewList([HBTIHomeItem])
        case setIsPushNoteSurvey(Bool)
        case setIsPushPerfumeSurvey(Bool)
        case setIsPushAllReviewList(Bool)
        case setReviewLike(Int)
        case cancelReviewLike(Int)
    }
    
    struct State {
        var isPushNoteSurvey: Bool = false
        var isPushPerfumeSurvey: Bool = false
        var isPushAllReviewList: Bool = false
        var topReviewList: [HBTIHomeItem] = []
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return setTopReviewList()
            
        case .didTapSurveyCell(let row):
            if row == 0 {
                return .concat([
                    .just(.setIsPushNoteSurvey(true)),
                    .just(.setIsPushNoteSurvey(false))
                ])
            } else {
                return .concat([
                    .just(.setIsPushPerfumeSurvey(true)),
                    .just(.setIsPushPerfumeSurvey(false))
                ])
            }
            
        case .didTapSeeAllReviewButton:
            return .concat([
                .just(.setIsPushAllReviewList(true)),
                .just(.setIsPushAllReviewList(false))
            ])
            
        case .didTapLikeButton(let index):
            return setReviewLike(index: index)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setTopReviewList(let item):
            state.topReviewList = item
            
        case .setIsPushNoteSurvey(let isTap):
            state.isPushNoteSurvey = isTap
            
        case .setIsPushPerfumeSurvey(let isTap):
            state.isPushPerfumeSurvey = isTap
            
        case .setIsPushAllReviewList(let isPush):
            state.isPushAllReviewList = isPush
            
        case .setReviewLike(let index):
            guard var review = state.topReviewList[index].review else { break }
            review.isLiked = true
            review.likeCount += 1
            state.topReviewList[index] = HBTIHomeItem.review(review)
        
        case .cancelReviewLike(let index):
            guard var review = state.topReviewList[index].review else { break }
            review.isLiked = false
            review.likeCount -= 1
            state.topReviewList[index] = HBTIHomeItem.review(review)
        }
        
        return state
    }
}

extension HBTIReactor {
    func setTopReviewList() -> Observable<Mutation> {
        return HBTIAPI.fetchReivewList(fromMember: false, page: 0)
            .catch { _ in .empty() }
            .flatMap { reviewListData -> Observable<Mutation> in
                let listData = reviewListData.data.map { review in
                    return HBTIHomeItem.review(review)
                }
                
                return .concat([
                    .just(.setTopReviewList(listData))
                ])
            }
    }
    
    func setReviewLike(index: Int) -> Observable<Mutation> {
        guard let review = currentState.topReviewList[index].review else { return .empty() }
        
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
}
