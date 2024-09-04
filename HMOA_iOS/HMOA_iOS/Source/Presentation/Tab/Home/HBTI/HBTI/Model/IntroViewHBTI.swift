//
//  IntroViewHBTI.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/13/24.
//

import Foundation

enum IntroViewHBTI {
    case first
    case second
    case third
}

extension IntroViewHBTI {
    var title: String {
        switch self {
        case .first:
            "\"엇?! 저 향기 뭐지?\""
        case .second:
            "\"하지만..이게 어떤 향이야?\""
        case .third:
            "\"그래서 이 향이 들어간 향수가 뭔데?\""
        }
    }
    
    var desctiprion: String {
        switch self {
        case .first:
            """
            했던 경험 많이들 있으시지 않나요?
            보통 우리는 특정 향수를 선호하기도 하지만, 그 향수를 구성하고 있는 ‘향료’에 이끌려 이런 현상을 경험하게 됩니다.
            """
        case .second:
            """
            향료들은 시더우드, 피오니, 베르가못과 같이 우리에게 친숙하지 않은 단어들이 대부분입니다.
            향BTI는 향료들을 소비자에게 직접 배송해서 소비자가 선호하고 원하는 향료를 찾아낼 수 있도록 도움을 제공합니다.
            """
        case .third:
            """
            소비자가 선호하는 향료 데이터를 수집한 후, 그 향료가 들어간 향수를 종합적으로 추천합니다.
            """
        }
    }
}
