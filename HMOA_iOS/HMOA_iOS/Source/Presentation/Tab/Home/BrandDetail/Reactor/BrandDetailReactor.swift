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
        case didTapBackButton
    }
    
    enum Mutation {
        case setPopVC(Bool)
    }
    
    struct State {
        var section: [BrandDetailSection] = []
        var brandId: Int = 0
        var title: String = ""
        var isPopVC: Bool = false
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPopVC(let isPop):
            state.isPopVC = isPop
        }
        
        return state
    }
}


extension BrandDetailReactor {
    
    func requestBrandInfo(_ brandId: Int) -> Observable<Mutation> {
        
    }
}
