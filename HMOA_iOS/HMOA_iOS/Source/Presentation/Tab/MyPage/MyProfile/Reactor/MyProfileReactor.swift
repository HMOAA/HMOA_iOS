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
        case didTapCell(IndexPath)
    }
    
    enum Mutation {
        case setPresentVC(UIViewController?)
    }
    
    struct State {
        var sections: [MyProfileSection]
        var presentVC: UIViewController? = nil
    }
    
    init() {
        self.initialState = State(
            sections: MyProfileReactor.setUpSection()
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCell(let indexPath):
            
            switch indexPath.section {
            case 0:
                return .concat([
                    .just(.setPresentVC(ChangeNicknameViewController())),
                    .just(.setPresentVC(nil))
                ])
            default:
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentVC(let vc):
            state.presentVC = vc
        }
        
        return state
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
