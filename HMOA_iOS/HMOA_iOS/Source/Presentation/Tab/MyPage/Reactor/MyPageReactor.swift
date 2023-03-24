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
        case didTapCell(IndexPath)
    }
    
    enum Mutation {
        case setPresentVC(UIViewController?)
    }
    
    struct State {
        var sections: [MyPageSection]
        var presentVC: UIViewController? = nil
    }
    
    init() {
        initialState = State(sections: MyPageReactor.reqeustUserInfo())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        }
        
        return state
    }
}

extension MyPageReactor {
    
    static func reqeustUserInfo() -> [MyPageSection] {
        
        let data = UserInfo(
            imageUrl: "test",
            nickName: "닉네임",
            loginType: "카카오톡 로그인")
        let firstSection = MyPageSection.first(MyPageSectionItem.userInfo(data))
        
        let secondSection = MyPageSection.etc(myPageType.setting.title.map { MyPageSectionItem.etc($0) })
        
        let thridSection = MyPageSection.etc(myPageType.infomation.title.map { MyPageSectionItem.etc($0) })
        
        let fourthSection = MyPageSection.etc(myPageType.user.title.map { MyPageSectionItem.etc($0) })
        
        return [firstSection, secondSection, thridSection, fourthSection]
    }
    
    func matchingViewController(_ indexPath: IndexPath) -> Observable<Mutation> {
            
        return .just(.setPresentVC(myPageType.allCases[indexPath.section - 1].viewController[indexPath.row]))
        
    }
}
