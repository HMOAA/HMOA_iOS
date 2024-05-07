//
//  MyLogCommentSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/20/23.
//

import Foundation


enum MyLogCommentSection: Hashable {
    case comment
}

enum MyLogCommentSectionItem: Hashable {
    case commentCell(MyLogComment?)
}

enum MyLogCommentType: Hashable {
    case liked
    case writed
}
