//
//  HPediaTagCellReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/08.
//

import Foundation

import ReactorKit

class HPediaTagCellReactor: Reactor {
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var id: Int
        var name: String
    }
    
    init(tag: HPediaTagData) {
        initialState = State(id: tag.id, name: tag.name)
    }
}
