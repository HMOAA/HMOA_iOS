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
        var profileImage: UIImage? = nil
    }
    
    init(member: Member, profileImage: UIImage? = nil) {
        initialState = State(member: member, profileImage: profileImage)
    }
}
