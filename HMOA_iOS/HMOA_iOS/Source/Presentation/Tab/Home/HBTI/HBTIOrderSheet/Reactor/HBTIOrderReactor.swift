//
//  HBTIOrderReactor.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/9/24.
//

import RxSwift
import ReactorKit

final class HBTIOrderReactor: Reactor {
    
    enum Action {
        case didChangeName(String)
        case didChangeContact(String)
    }
    
    enum Mutation {
        case setName(String)
        case setContact(String)
        case setPayValid(Bool)
    }
    
    struct State {
        var name: String = ""
        var contact: String = ""
        var isPayValid: Bool = false
    }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didChangeName(name):
            let isValid = isPayValid(name: name, contact: currentState.contact)
            
            return .concat([
                .just(.setName(name)),
                .just(.setPayValid(isValid))
            ])
            
        case let .didChangeContact(contact):
            let isValid = isPayValid(name: currentState.name, contact: contact)
            
            return .concat([
                .just(.setContact(contact)),
                .just(.setPayValid(isValid))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setName(name):
            state.name = name
            
        case let .setContact(contact):
            state.contact = contact
            
        case let .setPayValid(isValid):
            state.isPayValid = isValid
        }
        return state
    }
}

extension HBTIOrderReactor {
    // 주문자 정보 유효성 검사
    private func isPayValid(name: String, contact: String) -> Bool {
        return !name.isEmpty && contact.count == 13
    }
}
