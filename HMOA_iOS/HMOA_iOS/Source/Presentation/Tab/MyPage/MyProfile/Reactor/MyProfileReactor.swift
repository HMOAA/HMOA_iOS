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
        case updateNickname(String)
        case updateAge(Int)
        case updateSex(Bool)
    }
    
    struct State {
        var sections: [MyProfileSection]
        var member: Member
        var presentVC: MyProfileType? = nil
    }
    
    init(service: UserServiceProtocol, member: Member) {
        self.initialState = State(
            sections: MyProfileReactor.setUpSection(),
            member: member
        )
        
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateNickname(content: let nickname):
                return .just(.updateNickname(nickname))
            case .updateImage(content: _):
                return .empty()
            case .updateUserAge(content: let age):
                return .just(.updateAge(age))
            case .updateUserSex(content: let sex):
                return .just(.updateSex(sex))
            }
        }
        
        return Observable.merge(mutation, event)
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
        case .updateNickname(let nickname):
            state.member.nickname = nickname
        case .updateAge(let age):
            state.member.age = age
        case .updateSex(let sex):
            state.member.sex = sex
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
        return ChangeNicknameReactor(service: service, currentNickname: currentState.member.nickname)
    }
    
    func reactorForChangeYear() -> ChangeYearReactor {
        return ChangeYearReactor(service: UserYearService(), selectedYear: currentState.member.age.ageToYear(), userService: service)
    }
    
    func reactorForChangeSex() -> ChangeSexReactor {
        return ChangeSexReactor(currentState.member.sex, service: service)
    }
}
