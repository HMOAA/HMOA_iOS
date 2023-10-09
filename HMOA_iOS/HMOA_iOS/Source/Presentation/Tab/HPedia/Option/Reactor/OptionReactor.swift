//
//  OptionReactor.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import Foundation

import RxSwift
import ReactorKit

class OptionReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var options: [String]
    }
    
    init(_ options: [String]) {
        initialState = State(options: options)
    }
}
