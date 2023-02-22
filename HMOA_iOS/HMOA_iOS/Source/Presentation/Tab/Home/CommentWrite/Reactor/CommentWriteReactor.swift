//
//  CommentWriteReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import ReactorKit
import RxSwift

class CommentWriteReactor: Reactor {
    var initialState: State
    var currentPerfumeId: Int
    
    enum Action {
        case didTapOkButton
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var content: String
    }
    
    init(_ currentPerfumeId: Int) {
        self.currentPerfumeId = currentPerfumeId
        self.initialState = State(content: "테스트")
    }
}
