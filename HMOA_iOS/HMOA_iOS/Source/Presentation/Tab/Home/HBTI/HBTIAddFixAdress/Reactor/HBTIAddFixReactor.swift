//
//  HBTIAddFixReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/11/24.
//

import RxSwift
import ReactorKit

final class HBTIAddFixReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var name: String = ""
        var addressName: String = ""
        var phoneNumber: String = ""
        var telephoneNumber: String = ""
        var zipCode: String = ""
        var address: String = ""
        var detailAddress: String = ""
        var orderRequest: String = ""
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
       
        }
        
        return state
    }
}
