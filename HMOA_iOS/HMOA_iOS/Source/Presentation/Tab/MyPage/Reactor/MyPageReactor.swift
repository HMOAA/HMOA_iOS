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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var sections: [MyPageSection]
    }
    
    init() {
        initialState = State(sections: MyPageReactor.reqeustUserInfo())
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
}
