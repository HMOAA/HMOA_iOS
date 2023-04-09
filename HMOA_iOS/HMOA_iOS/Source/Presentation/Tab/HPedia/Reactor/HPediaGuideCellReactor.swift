//
//  HPediaCellReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/08.
//

import Foundation

import ReactorKit

class HPediaGuideCellReactor: Reactor {
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutaition {
        
    }
    
    struct State {
        var id: Int
        var title: String
        var content: String
    }
    
    init(guide: HPediaGuideData) {
        initialState = State(id: guide.id, title: guide.title, content: guide.content)
    }
}
