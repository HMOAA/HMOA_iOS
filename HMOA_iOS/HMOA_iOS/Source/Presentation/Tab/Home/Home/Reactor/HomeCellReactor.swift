//
//  HomeCellReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import ReactorKit

class HomeCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var title: String
        var content: String
        var image: UIImage
    }
    
    init(perfume: Perfume) {
        self.initialState = State(title: perfume.titleName, content: perfume.content, image: perfume.image)
    }
}
