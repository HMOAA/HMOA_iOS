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
        case didTapPerfume(Int)
        case didTapLikeSortButton
        case viewDidLoad
        case willDisplayCell(Int)
    }
    
    enum Mutation {
        case setPresentPerfumeId(Int?)
        case setSections([BrandDetailSection])
        case setBrand(Brand)
        case setIsTapLiked(Bool)
        case setLoadedPage(Int)
    }
    
    struct State {
        var section: [BrandDetailSection] = []
        var brand: Brand? = nil
        var brandId: Int = 0
        var isTapLiked: Bool = false
        var presentPerfumeId: Int? = nil
        var loadedPage: Set<Int> = []
    }
    
    var initialState: State
    
    init(_ brandId: Int) {
        initialState = State(brandId: brandId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            return .concat([
                requestBrandInfo(),
                fetchBrandFerfumeList(0, false)
            ])
            
        case .didTapLikeSortButton:
            let currentState = currentState
            let isTapLiked = !currentState.isTapLiked
            return .concat([
                fetchBrandFerfumeList(0, isTapLiked),
                .just(.setIsTapLiked(isTapLiked))
            ])
        case .didTapPerfume(let item):
            return .concat([
                .just(.setPresentPerfumeId(currentState.section[0].items[item].perfumeId)),
                .just(.setPresentPerfumeId(nil))
            ])
            
        case .willDisplayCell(let page):
            return fetchBrandFerfumeList(page, currentState.isTapLiked)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {

        case .setSections(let section):
            state.section = section
            
        case .setBrand(let brand):
            state.brand = brand
            
            
        case .setIsTapLiked(let isTap):
            if state.isTapLiked != isTap { // 중복을 방지하기 위한 조건
                state.isTapLiked = isTap
            }
        case .setPresentPerfumeId(let id):
            state.presentPerfumeId = id
            
        case .setLoadedPage(let page):
            if page == 0 { state.loadedPage = [] }
            state.loadedPage.insert(page)
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
    
    func fetchBrandFerfumeList(_ page: Int, _ isTapLiked: Bool) -> Observable<Mutation> {
        if page != 0 && currentState.loadedPage.contains(page) { return .empty() }
        // 좋아요 순
        let type = isTapLiked ? "top" : ""
        let query = ["pageNum": page]
        
        return BrandAPI.fetchBrandList(query, brandId: currentState.brandId, type: type)
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                let item = data.data.map { BrandDetailSectionItem.perfumeList($0) }
                
                var updatedSection: BrandDetailSection!
                if page == 0 {
                    let section = BrandDetailSection.first(item)
                    return .concat([
                        .just(.setSections([section])),
                        .just(.setLoadedPage(page))
                    ])
                } else { updatedSection = self.currentState.section.first }

                if case .first(var items) = updatedSection {
                    items.append(contentsOf: item)
                    updatedSection = .first(items)
                }
                
                return .concat([
                    .just(.setSections([updatedSection])),
                    .just(.setLoadedPage(page))
                ])
            }
    }
}
