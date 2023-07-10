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
        case updateProfileImage(UIImage?)
    }
    
    struct State {
        var sections: [MyProfileSection]
        var member: Member
        var profileImage: UIImage? = nil
        var presentVC: MyProfileType? = nil
    }
    
    init(service: UserServiceProtocol, member: Member, profileImage: UIImage?) {
        self.initialState = State(
            sections: MyProfileReactor.setUpSection(),
            member: member,
            profileImage: profileImage
        )
        
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateNickname(content: let nickname):
                return .just(.updateNickname(nickname))
                
            case .updateImage(content: let imageUrl):
                return .just(.updateProfileImage(imageUrl))
                
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
            
        case .updateProfileImage(let image):
            state.profileImage = image
            
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
        var sections = [MyProfileSection]()
        
        MyProfileType.allCases.forEach {
            sections.append(MyProfileSection.section([MyProfileItem.item($0.title)]))
        }
        
        
        return sections
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
    
    func reactorForChangeProfileImage() -> ChangeProfileImageReactor {
        return ChangeProfileImageReactor(service: service, currentImage: currentState.profileImage)
    }
}
