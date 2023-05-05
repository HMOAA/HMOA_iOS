//
//  MyProfileReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/05.
//

import Foundation
import ReactorKit

class MyProfileReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [MyProfileSection]
    }
    
    init() {
        self.initialState = State(
            sections: MyProfileReactor.setUpSection()
        )
    }
}

extension MyProfileReactor {
    
    static func setUpSection() -> [MyProfileSection] {
        let nickname = MyProfileSection.nickname([MyProfileItem.nickname("닉네임")])
        
        let year = MyProfileSection.year([MyProfileItem.year("출생연도")])

        let sex = MyProfileSection.sex([MyProfileItem.sex("성별")])
        
        let section = [nickname, year, sex]
        
        return section
    }
}
