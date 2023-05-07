//
//  MyProfileReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/05.
//

import Foundation
import ReactorKit

class MyProfileReactor: Reactor {
    var service: UserServiceProtocol
    var initialState: State
    
    enum Action {
        case didTapCell(MyProfileType)
    }
    
    enum Mutation {
        case setPresentVC(MyProfileType?)
    }
    
    struct State {
        var sections: [MyProfileSection]
        var presentVC: MyProfileType? = nil
    }
    
    init(service: UserServiceProtocol) {
        self.initialState = State(
            sections: MyProfileReactor.setUpSection()
        )
        
        self.service = service
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCell(let type):
            return .concat([
                .just(.setPresentVC(type)),
                .just(.setPresentVC(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentVC(let type):
            state.presentVC = type
        }
        
        return state
    }
}

extension MyProfileReactor {
    
    static func setUpSection() -> [MyProfileSection] {
        let nickname = MyProfileSection.nickname(
            [MyProfileType.nickname.title].map { MyProfileItem.nickname($0) })
        
        let year = MyProfileSection.year(
            [MyProfileType.year.title].map { MyProfileItem.year($0) })

        let sex = MyProfileSection.sex(
            [MyProfileType.sex.title].map { MyProfileItem.sex($0) })
        
        let section = [nickname, year, sex]
        
        return section
    }
    
    func reactorForChangeNickname() -> ChangeNicknameReactor {
        return ChangeNicknameReactor(service: service)
    }
}
