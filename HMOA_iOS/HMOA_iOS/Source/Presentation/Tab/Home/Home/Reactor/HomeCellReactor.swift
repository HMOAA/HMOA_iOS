//
//  HomeCellReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import ReactorKit

/// 홈 화면 추천 향수 Cell Reactor
class HomeCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var title: String
        var content: String
        var image: String
    }
    
    init(perfume: RecommendPerfume) {
        self.initialState = State(title: perfume.brandName, content: perfume.perfumeName, image: perfume.imgUrl)
    }
}
