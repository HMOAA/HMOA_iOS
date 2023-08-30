//
//  ListSecton.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation


enum LikeSection: Hashable {
    case main
}

struct LikeSectionItem: Hashable {
    var item: [Like]
}
