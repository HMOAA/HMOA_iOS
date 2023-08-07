//
//  MemberCellReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/16.
//

import ReactorKit

class MemberCellReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case didTapEditButton
    }
    
    enum Mutation {
        case setIsTapEditButton(Bool)
    }
    
    struct State {
        var member: Member?
        var profileImage: UIImage? = nil
        var isTapEditButton: Bool = false
    }
    
    init(member: Member?, profileImage: UIImage? = nil) {
        initialState = State(member: member, profileImage: profileImage)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapEditButton:
            print("asdf")
            return .concat([
                .just(.setIsTapEditButton(true)),
                .just(.setIsTapEditButton(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .setIsTapEditButton(let isTap):
            state.isTapEditButton = isTap
        }
        
        return state
    }
}
