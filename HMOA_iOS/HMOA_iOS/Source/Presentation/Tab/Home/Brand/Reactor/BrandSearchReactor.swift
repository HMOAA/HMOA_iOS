//
//  BrandSearchReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import ReactorKit
import RxSwift

class BrandSearchReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewDidLoad
        case didTapBackButton
    }
    
    enum Mutation {
        case setIsPopVC(Bool)
        case setBrandList([Brand])
    }
    
    struct State {
        var isPopVC: Bool = false
        var brandList: [Brand] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .didTapBackButton:
            return .concat([
                .just(.setIsPopVC(true)),
                .just(.setIsPopVC(false))
            ])
            
        case .viewDidLoad:
            return reqeustBrandList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsPopVC(let isPop):
            state.isPopVC = isPop
            
        case .setBrandList(let list):
            state.brandList = list
        }
        
        return state
    }
}

extension BrandSearchReactor {
    
    func reqeustBrandList() -> Observable<Mutation>{
        
        let data: [Brand] = [
            Brand(brandId: 1, brandName: "구찌"),
            Brand(brandId: 2, brandName: "구찌"),
            Brand(brandId: 3, brandName: "구찌"),
            Brand(brandId: 4, brandName: "구찌"),
            Brand(brandId: 5, brandName: "구찌"),
            Brand(brandId: 6, brandName: "구찌"),
            Brand(brandId: 7, brandName: "구찌"),
            Brand(brandId: 8, brandName: "구찌"),
            Brand(brandId: 9, brandName: "구찌"),
            Brand(brandId: 10, brandName: "구찌"),
            Brand(brandId: 11, brandName: "구찌"),
            Brand(brandId: 12, brandName: "구찌"),
            Brand(brandId: 13, brandName: "구찌"),
            Brand(brandId: 14, brandName: "구찌"),
            Brand(brandId: 15, brandName: "구찌"),
            Brand(brandId: 16, brandName: "구찌"),
            Brand(brandId: 17, brandName: "구찌")
        ]
        
        return .just(.setBrandList(data))
    }
}
