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
        case didTapOptionButton(HBTIReview?)
        case didTapDeleteReview
        case didTapEditReview
    }
    
    enum Mutation {
        case setTopReviewList([HBTIHomeItem])
        case setIsPushNoteSurvey(Bool)
        case setIsPushPerfumeSurvey(Bool)
        case setIsPushAllReviewList(Bool)
        case setReviewLike(Int)
        case cancelReviewLike(Int)
        case setSelectedReview(HBTIReview?)
        case setIsEditReview(Bool)
    }
    
    struct State {
        var isPushNoteSurvey: Bool = false
        var isPushPerfumeSurvey: Bool = false
        var isPushAllReviewList: Bool = false
        var topReviewList: [HBTIHomeItem] = []
        var selectedReview: HBTIReview? = nil
        var isEditReivew: Bool = false
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
            
        case .didTapOptionButton(let review):
            return .concat([
                .just(.setSelectedReview(review))
            ])
            
        case .didTapDeleteReview:
            return .concat([
                deleteSelectedReview(),
                .just(.setSelectedReview(nil))
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
            
        case .setSelectedReview(let review):
            state.selectedReview = review
            
        case .setIsEditReview(let isEdit):
            state.isEditReivew = isEdit
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
    
    func deleteSelectedReview() -> Observable<Mutation> {
        guard let review = currentState.selectedReview else { return .empty() }
        var reviewList = currentState.topReviewList
        let index = reviewList.firstIndex(of: .review(review))!
        reviewList.remove(at: index)
        
        return HBTIAPI.deleteReivew(id: review.id)
            .catch { _ in .empty() }
            .flatMap { _ -> Observable<Mutation> in
                return .just(.setTopReviewList(reviewList))
            }
    }
}
