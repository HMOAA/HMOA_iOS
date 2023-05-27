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
        case setMemberInfo([MyPageSection])
        case updateNickname(String)
    }
    
    struct State {
        var sections: [MyPageSection]
        var presentVC: MyPageType? = nil
    }
    
    init(service: UserServiceProtocol) {
        let sections = [
            MyPageSection.first(MyPageSectionItem.userInfo(
                UserInfo(
                    imageUrl: "",
                    nickName: "",
                    loginType: "")))] + MyPageReactor.setUpSection()

        self.initialState = State(sections: sections)
        self.service = service
        
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateNickname(content: let nickname):
                return .just(.updateNickname(nickname))
            case .updateImage(content: _):
                return .empty()
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
        case .setMemberInfo(let sections):
            state.sections = sections
        case .updateNickname(let nickname):
            state.sections = [
                MyPageSection.first(MyPageSectionItem.userInfo(
                    UserInfo(
                        imageUrl: "",
                        nickName: nickname,
                        loginType: "")))
            ] + MyPageReactor.setUpSection()
        }
        
        return state
    }
}

extension MyPageReactor {
    
    static func setUpSection() -> [MyPageSection] {
        let second = [
            MyPageType.myLog.title,
            MyPageType.myProfile.title
            ]   .map { MyPageSectionItem.etc($0) }

        let thrid = [
            MyPageType.openSource.title,
            MyPageType.policy.title,
            MyPageType.version.title
            ]   .map { MyPageSectionItem.etc($0)}
        
        let fourth = [
            MyPageType.logout.title,
            MyPageType.deleteAccount.title
            ]   .map { MyPageSectionItem.etc($0)}
        
        
        return [MyPageSection.etc(second), MyPageSection.etc(thrid), MyPageSection.etc(fourth)]
    }
    
    static func reqeustUserInfo() -> Observable<Mutation> {
        
        return MemberAPI.getMember()
            .catch { _ in .empty() }
            .flatMap { member -> Observable<Mutation> in
                let sections = [
                    MyPageSection.first(MyPageSectionItem.userInfo(
                        UserInfo(
                            imageUrl: "",
                            nickName: member!.nickname!,
                            loginType: member!.provider!))),
                ] + MyPageReactor.setUpSection()
                
                return .just(.setMemberInfo(sections))
            }
    }

    
    func reactorForMyProfile() -> MyProfileReactor {
        return MyProfileReactor(service: service)
    }
}
