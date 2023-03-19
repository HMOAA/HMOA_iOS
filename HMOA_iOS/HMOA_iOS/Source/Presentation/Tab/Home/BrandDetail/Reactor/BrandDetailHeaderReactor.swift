//
//  BrandDetailHeaderReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import ReactorKit
import RxSwift

class BrandDetailHeaderReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapBrandLikeButton(Bool)
    }
    
    enum Mutation {
        case setBrandLike(Bool)
    }
    
    struct State {
        var brandInfo: BrandInfo
    }
    
    init(_ brandId: Int) {
        
        // 받아온 brandId로 브랜드 정보 받아오기
        self.initialState = State(brandInfo: BrandDetailHeaderReactor.requestBrandInfo(brandId))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBrandLikeButton(let isLike):
            return .just(.setBrandLike(isLike))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setBrandLike(let isLike):
            state.brandInfo.isLikeBrand = isLike
        }
        
        return state
    }
}

extension BrandDetailHeaderReactor {
    
    static func requestBrandInfo(_ brandId: Int) -> BrandInfo {
     
        let data = BrandInfo(
            brandId: brandId,
            koreanName: "조말론 런던",
            EnglishName: "JO MALONE LONDON",
            isLikeBrand: false)
        
        return data
    }
}
