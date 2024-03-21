//
//  MagazineDetailItem.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import Foundation

enum MagazineDetailSection: Hashable {
    case title
    case content
    case like
    case latestMagazine
}

enum MagazineDetailItem: Hashable, Codable {
    case info(MagazineInfo)
    case magazineContent(MagazineContent)
    case like(MagazineLike)
    case magazineRecommend(Magazine)
}

extension MagazineDetailItem {
    var info: MagazineInfo? {
        if case .info(let magazineInfo) = self {
            return magazineInfo
        } else {
            return nil
        }
    }
    
    var contents: MagazineContent? {
        if case .magazineContent(let magazineContent) = self {
            return magazineContent
        } else {
            return nil
        }
    }
    
    var like: MagazineLike? {
        if case .like(let magazineLike) = self {
            return magazineLike
        } else {
            return nil
        }
    }
    
    var magazineRecommend: Magazine? {
        if case .magazineRecommend(let magazine) = self {
            return magazine
        } else {
            return nil
        }
    }
    
    // initial snapshot items
    static let magazineInfo: MagazineDetailItem = .info(MagazineInfo(title: "제목 샘플", releasedDate: "날짜 샘플", viewCount: 123456))
    
    static let magazineContents: [MagazineDetailItem] = [
        .magazineContent(MagazineContent(type: "header", data: "헤더")),
        .magazineContent(MagazineContent(type: "content", data: "내용")),
        .magazineContent(MagazineContent(type: "image", data: "이미지")),
        .magazineContent(MagazineContent(type: "content", data: "내용2"))
    ]
    
    static let magazineLike: MagazineDetailItem = .like(MagazineLike(likeCount: 1234))
    
    static let otherMagazines: [MagazineDetailItem] = [
        .magazineRecommend(Magazine(id: 1, slogan: "시들지 않는 아름다움,", perfumeName: "샤넬 오드 롱 코롱", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다.", releaseDate: "2024.03.05", content: "건강과 지속 가능성을 추구하는 이들을 위해, 맛과 영양이 가득한 채식 요리 레시피를 소개합니다. 이 글에서는 간단하지만 맛있는 채식 요리 10가지를 선보입니다. 첫 번째 레시피는 아보카도 토스트, 아침 식사로 완벽하며 영양소가 풍부합니다. 두 번째는 콩과 야채를 사용한 푸짐한 채식 칠리, 포만감을 주는 동시에 영양소를 공급합니다. 세 번째는 색다른 맛의 채식 패드타이, 고소한 땅콩 소스로 풍미를 더합니다. 네 번째는 간단하고 건강한 콥 샐러드, 신선한 야채와 단백질이 가득합니다. 다섯 번째로는 향긋한 허브와 함께하는 채식 리조또, 크리미한 맛이 일품입니다. 여섯 번째는 에너지를 주는 채식 스무디 볼, 과일과 견과류의 완벽한 조합입니다. 일곱 번째는 건강한 채식 버거, 만족감 있는 식사를 제공합니다. 여덟 번째는 채식 파스타 프리마베라, 신선한 야채와 토마토 소스의 조화가 뛰어납니다. 아홉 번째는 채식 볶음밥, 풍부한 맛과 영양으로 가득 차 있습니다. 마지막으로, 식사 후 달콤한 마무리를 위한 채식 초콜릿 케이크, 건강한 재료로 만들어 죄책감 없는 달콤함을 선사합니다. 이 레시피들은 채식을 선호하는 이들에게 새로운 요리 아이디어를 제공하며, 채식이 얼마나 다채롭고 맛있을 수 있는지 보여줍니다. 건강한 라이프스타일을 추구하는 모든 이들에게 이 레시피들이 영감을 줄 것입니다.", liked: false, likeCount: 12304)),
        .magazineRecommend(Magazine(id: 2,slogan: "로맨틱한 장미향의 끝,", perfumeName: "디올 로즈 앤 로지스", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다.", releaseDate: "2024.03.05", content: "건강과 지속 가능성을 추구하는 이들을 위해, 맛과 영양이 가득한 채식 요리 레시피를 소개합니다. 이 글에서는 간단하지만 맛있는 채식 요리 10가지를 선보입니다. 첫 번째 레시피는 아보카도 토스트, 아침 식사로 완벽하며 영양소가 풍부합니다.", liked: false, likeCount: 12304)),
        .magazineRecommend(Magazine(id: 3,slogan: "꿀과 이끼의 오묘한 조화,", perfumeName: "탬버린즈 카모", description: "일상 생활에 쉽게 통합할 수 있는 5가지 핵심 습관을 소개합니다." ,longDescription: "여행은 새로운 경험과 추억을 선사하지만, 올바른 준비가 필수입니다. 이번 블로그 포스트에서는 여행자가 가져가야 할 10가지 필수 아이템을 상세히 소개합니다.", releaseDate: "2024.03.05", content: "건강과 지속 가능성을 추구하는 이들을 위해, 맛과 영양이 가득한 채식 요리 레시피를 소개합니다. 이 글에서는 간단하지만 맛있는 채식 요리 10가지를 선보입니다. 첫 번째 레시피는 아보카도 토스트, 아침 식사로 완벽하며 영양소가 풍부합니다. 두 번째는 콩과 야채를 사용한 푸짐한 채식 칠리, 포만감을 주는 동시에 영양소를 공급합니다. 세 번째는 색다른 맛의 채식 패드타이, 고소한 땅콩 소스로 풍미를 더합니다. 네 번째는 간단하고 건강한 콥 샐러드, 신선한 야채와 단백질이 가득합니다. 다섯 번째로는 향긋한 허브와 함께하는 채식 리조또, 크리미한 맛이 일품입니다. 여섯 번째는 에너지를 주는 채식 스무디 볼, 과일과 견과류의 완벽한 조합입니다. 일곱 번째는 건강한 채식 버거, 만족감 있는 식사를 제공합니다..", liked: false, likeCount: 12304))
    ]
}
