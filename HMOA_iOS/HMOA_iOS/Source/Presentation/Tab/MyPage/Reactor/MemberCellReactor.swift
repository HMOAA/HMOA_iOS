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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var member: Member
    }
    
    init(member: Member) {
        initialState = State(member: member)
    }
}
