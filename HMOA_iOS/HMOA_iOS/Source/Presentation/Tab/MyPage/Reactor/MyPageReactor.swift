//
//  MyPageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import ReactorKit

class MyPageReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case viewDidLoad
        case didTapCell(IndexPath)
    }
    
    enum Mutation {
        case setPresentVC(UIViewController?)
        case setMemberInfo([MyPageSection])
    }
    
    struct State {
        var sections: [MyPageSection]
        var presentVC: UIViewController? = nil
    }
    
    init() {
        var sections = [
            MyPageSection.first(MyPageSectionItem.userInfo(
                UserInfo(
                    imageUrl: "",
                    nickName: "",
                    loginType: ""))),
            MyPageSection.etc(myPageType.setting.title.map { MyPageSectionItem.etc($0) }),
            MyPageSection.etc(myPageType.infomation.title.map { MyPageSectionItem.etc($0) }),
            MyPageSection.etc(myPageType.user.title.map { MyPageSectionItem.etc($0) })
        ]
        
        initialState = State(sections: sections)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            return MyPageReactor.reqeustUserInfo()
        case .didTapCell(let indexPath):
            
            if (1...2).contains(indexPath.section) {
                return .concat([
                    matchingViewController(indexPath),
                    .just(.setPresentVC(nil))
                ])
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentVC(let VC):
            state.presentVC = VC
        case .setMemberInfo(let sections):
            state.sections = sections
        }
        
        return state
    }
}

extension MyPageReactor {
    
    static func reqeustUserInfo() -> Observable<Mutation> {
        
        return MemberAPI.getMember()
            .catch { _ in .empty() }
            .flatMap { member -> Observable<Mutation> in
                let sections = [
                    MyPageSection.first(MyPageSectionItem.userInfo(
                        UserInfo(
                            imageUrl: "",
                            nickName: member.nickname,
                            loginType: member.email))),
                    MyPageSection.etc(myPageType.setting.title.map { MyPageSectionItem.etc($0) }),
                    MyPageSection.etc(myPageType.infomation.title.map { MyPageSectionItem.etc($0) }),
                    MyPageSection.etc(myPageType.user.title.map { MyPageSectionItem.etc($0) })]
                
                return .just(.setMemberInfo(sections))
            }
    }


    func matchingViewController(_ indexPath: IndexPath) -> Observable<Mutation> {
            
        return .just(.setPresentVC(myPageType.allCases[indexPath.section - 1].viewController[indexPath.row]))
        
    }
}
