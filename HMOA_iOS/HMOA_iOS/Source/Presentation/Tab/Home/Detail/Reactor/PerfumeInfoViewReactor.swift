//
//  PerfumeDetailReactor.swift
//  HMOA_iOSPerfumeInfoViewReactor//
//  Created by 임현규 on 2023/02/21.
//

import ReactorKit

class PerfumeInfoViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case didTapPerfumeLikeButton
        case didTapBrandLikeButton
    }
    
    enum Mutation {
        case setPerfumeLike(Bool)
        case setBrandLike(Bool)
    }
    
    struct State {
        var perfumeId: Int
        var perfumeImage: UIImage
        var likeCount: Int
        var koreanName: String
        var englishName: String
        var category: [String]
        var price: Int
        var volume: [Int]
        var age: Int
        var gender: String
        var BrandImage: UIImage
        var productInfo: String
        var topTasting: String
        var heartTasting: String
        var baseTasting: String
        var isLikePerfume: Bool
        var isLikeBrand: Bool
    }
    
    init(detail: PerfumeDetail) {
        self.initialState = State(
            perfumeId: detail.perfumeId,
            perfumeImage: detail.perfumeImage,
            likeCount: detail.likeCount,
            koreanName: detail.koreanName,
            englishName: detail.englishName,
            category: detail.category,
            price: detail.price,
            volume: detail.volume,
            age: detail.age,
            gender: detail.gender,
            BrandImage: detail.BrandImage,
            productInfo: detail.productInfo,
            topTasting: detail.topTasting,
            heartTasting: detail.heartTasting,
            baseTasting: detail.baseTasting,
            isLikePerfume: detail.isLikePerfume,
            isLikeBrand: detail.isLikeBrand
            )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBrandLikeButton:
            // TODO: 서버 통신
            if Int.random(in: 0...10).isMultiple(of: 2) {
                return .just(.setBrandLike(true))
            } else {
                return .just(.setBrandLike(false))
            }
            
        case .didTapPerfumeLikeButton:
            
            // TODO: 서버 통신
            // 임의로 랜덤하게 보내봄
            if Int.random(in: 0...10).isMultiple(of: 2) {
                return .just(.setPerfumeLike(true))
            } else {
                return .just(.setPerfumeLike(false))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPerfumeLike(let isLike):
            state.isLikePerfume = isLike
            state.likeCount += isLike ? 1 : -1
        case .setBrandLike(let isLike):
            state.isLikeBrand = isLike
        }
        
        return state
    }
}
