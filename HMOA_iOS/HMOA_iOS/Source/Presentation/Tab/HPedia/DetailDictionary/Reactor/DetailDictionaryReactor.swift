//
//  DetailDictionaryReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/26.
//

import Foundation

import ReactorKit
import RxSwift

class DetailDictionaryReactor: Reactor {
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let naviTitle: String
    }
    
    init(_ naviTitle: String) {
        initialState = State(naviTitle: naviTitle)
    }
}
