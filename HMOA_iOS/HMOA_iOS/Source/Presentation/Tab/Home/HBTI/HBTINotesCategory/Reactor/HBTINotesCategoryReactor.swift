//
//  HBTINotesCategoryReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/27/24.
//

import RxSwift
import ReactorKit

final class HBTINotesCategoryReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {

    }
    
    struct State {
        var selectedQuantity: Int
    }
    
    var initialState: State
    
    init(selectedQuantity: Int) {
        self.initialState = State(selectedQuantity: selectedQuantity)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
