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
    }
    
    enum Mutation {
    }
    
    struct State {
        var brandId: Int
        var title: String
    }
    
    var initialState: State
    
    init(_ brandId: Int, _ title: String) {
        initialState = State(brandId: brandId, title: title)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
