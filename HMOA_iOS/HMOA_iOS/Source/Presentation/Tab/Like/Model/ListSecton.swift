//
//  ListSecton.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation


enum ListSection {
    case main
}

struct ListSectionItem: Hashable {
    let id: Int
    let imgName: String
}
