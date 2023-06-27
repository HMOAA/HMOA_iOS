//
//  MyPageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import ReactorKit

class MyPageReactor: Reactor {
    
    var initialState: State
    var service: UserServiceProtocol
    
    enum Action {
        case viewDidLoad
        case didTapCell(MyPageType)
    }
    
    enum Mutation {
        case setPresentVC(MyPageType?)
        case setSections([MyPageSection])
        case setMember(Member)
        case updateNickname(String)
        case updateAge(Int)
        case updateSex(Bool)
    }
    
    struct State {
        var sections: [MyPageSection] = []
        var member = Member(
            age: 0,
            memberImageUrl: "",
            memberId: 0,
            nickname: "",
            provider: "",
            sex: false)
        var presentVC: MyPageType? = nil
    }
    
    init(service: UserServiceProtocol) {
        self.initialState = State()
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
            
        case .viewDidLoad:
            return MyPageReactor.reqeustUserInfo()
            
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
        case .setPresentVC(let VC):
            state.presentVC = VC
            
        case .setSections(let sections):
            state.sections = sections
            
        case .setMember(let memeber):
            state.member = memeber
            
        case .updateNickname(let nickname):
            
            state.member.nickname = nickname
            
            state.sections = [
                MyPageSection.memberSection(
                    MyPageSectionItem.memberCell(MemberCellReactor(member: state.member)))
            ] + MyPageReactor.setUpOtherSection()
            
        case .updateAge(let age):
            state.member.age = age
            
        case .updateSex(let sex):
            state.member.sex = sex
        }
        
        return state
    }
}

extension MyPageReactor {
    
    static func setUpOtherSection() -> [MyPageSection] {
        let second = [
            MyPageType.myLog.title,
            MyPageType.myProfile.title
            ]   .map { MyPageSectionItem.otherCell($0) }

        let thrid = [
            MyPageType.openSource.title,
            MyPageType.policy.title,
            MyPageType.version.title
            ]   .map { MyPageSectionItem.otherCell($0)}
        
        let fourth = [
            MyPageType.logout.title,
            MyPageType.deleteAccount.title
            ]   .map { MyPageSectionItem.otherCell($0)}
        
        
        return [MyPageSection.otherSection(second), MyPageSection.otherSection(thrid), MyPageSection.otherSection(fourth)]
    }
    
    static func reqeustUserInfo() -> Observable<Mutation> {
        
        return MemberAPI.getMember()
            .catch { _ in .empty() }
            .compactMap { $0 }
            .flatMap { member -> Observable<Mutation> in

                var sections = [MyPageSection]()
                
                guard var member = member else { return .empty() }

                member.provider.changeProvider()
                
                sections.append(MyPageSection.memberSection(
                    MyPageSectionItem.memberCell(MemberCellReactor(member: member))))
                
                sections += setUpOtherSection()
                
                return .concat([
                    .just(.setMember(member)),
                    .just(.setSections(sections))
                ])
            }
    }
    
    func reactorForMyProfile() -> MyProfileReactor {
        return MyProfileReactor(service: service, member: currentState.member)
    }
}
