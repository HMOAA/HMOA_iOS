//
//  BrandDetailReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import ReactorKit
import RxSwift

class BrandDetailReactor: Reactor {
    
    enum Action {
        case didTapLikeSortButton
        case didTapBackButton
        case viewDidLoad
    }
    
    enum Mutation {
        case setPopVC(Bool)
        case setSections([BrandDetailSection])
        case setBrand(Brand)
        case setIsTapLiked(Bool)
    }
    
    struct State {
        var section: [BrandDetailSection] = []
        var brand: Brand? = nil
        var isPopVC: Bool = false
        var brandId: Int = 0
        var isTapLiked: Bool = false
    }
    
    var initialState: State
    
    init(_ brandId: Int) {
        initialState = State(brandId: brandId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setPopVC(true)),
                .just(.setPopVC(false))
            ])
        case .viewDidLoad:
            return .concat([
                requestBrandInfo(),
                fetchBrandFerfumeList(false)
            ])
            
        case .didTapLikeSortButton:
            let currentState = currentState
            let isTapLiked = !currentState.isTapLiked
            return .concat([
                fetchBrandFerfumeList(isTapLiked),
                .just(.setIsTapLiked(isTapLiked))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPopVC(let isPop):
            state.isPopVC = isPop
            
        case .setSections(let section):
            state.section = section
            
        case .setBrand(let brand):
            state.brand = brand
            
            
        case .setIsTapLiked(let isTap):
            if state.isTapLiked != isTap { // 중복을 방지하기 위한 조건
                state.isTapLiked = isTap
            }
        }
        
        
        return state
    }
}


extension BrandDetailReactor {

    func requestBrandInfo() -> Observable<Mutation> {
        BrandAPI.fetchBrandInfo(brandId: currentState.brandId)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .just(.setBrand(data.data))
            }
    }
    
    func fetchBrandFerfumeList(_ isTapLiked: Bool) -> Observable<Mutation> {
        
        // 좋아요 순
        let type = isTapLiked ? "top" : ""
        
        return BrandAPI.fetchBrandList(["pageNum": 0], brandId: currentState.brandId, type: type)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let item = data.data.map { BrandDetailSectionItem.perfumeList($0) }
                let firstSection = BrandDetailSection.first(item)
                
                return .just(.setSections([firstSection]))
            }
    }
}
