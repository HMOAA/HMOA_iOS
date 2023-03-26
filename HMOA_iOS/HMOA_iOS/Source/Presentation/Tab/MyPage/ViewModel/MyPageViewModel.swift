//
//  MyPageViewModel.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/21.
//

import UIKit

enum myPageType: CaseIterable {
    case setting
    case infomation
    case user
    
    var title: [String] {
        switch self {
        case .setting:
            return ["내 활동", "내 정보관리"]
        case .infomation:
            return ["오픈소스 라이센스", "개인정보 처리방침", "버전정보 1.0.0"]
        case .user:
            return ["로그아웃", "계정삭제"]
        }
    }
    
    var viewController: [UIViewController] {
        switch self {
        case .setting:
            return [MyLogViewController(), MyProfileViewController()]
        case .infomation:
            return [OpenSourceViewController(), PolicyViewController(), VersionViewController()]
        case .user:
            return [UIViewController(), UIViewController()]
        }
    }
}


class MyPageViewModel {
    
    let type: [myPageType] = [.setting, .infomation, .user]
    
    var numOfSection: Int {
        return type.count
    }
    
    func numOfCell(_ section: Int) -> Int {
        return type[section].title.count
    }
    
    func titleOfCell(_ index: IndexPath) -> String {
        return type[index.section].title[index.row]
    }
}
