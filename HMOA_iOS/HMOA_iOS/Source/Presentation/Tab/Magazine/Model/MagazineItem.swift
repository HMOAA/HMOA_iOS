//
//  MagazineItem.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import Foundation

enum MagazineItem: Hashable {
    case magazine(Magazine)
    
    var magazine: Magazine? {
        if case .magazine(let magazine) = self {
            return magazine
        } else {
            return nil
        }
    }
    
    static let mainMagazines: [MagazineItem] = [
        .magazine(Magazine(slogan: "시들지 않는 아름다움,", perfumeName: "샤넬 오드 롱 코롱", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다.")),
        .magazine(Magazine(slogan: "로맨틱한 장미향의 끝,", perfumeName: "디올 로즈 앤 로지스", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다.")),
        .magazine(Magazine(slogan: "꿀과 이끼의 오묘한 조화,", perfumeName: "탬버린즈 카모", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다."))
    ]
}
