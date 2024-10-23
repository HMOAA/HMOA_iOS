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
        case viewDidLoad
        case didTapSurveyCell(Int)
        case didTapSeeAllReviewButton
    }
    
    enum Mutation {
        case setTopReviewList([HBTIHomeItem])
        case setIsPushNoteSurvey(Bool)
        case setIsPushPerfumeSurvey(Bool)
        case setIsPushAllReviewList(Bool)
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
        case .viewDidLoad:
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
        }
        
        return state
    }
}

extension HBTIReactor {
    func setTopReviewList() -> Observable<Mutation> {
        return HBTIAPI.fetchReivewList(page: 0)
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
}
