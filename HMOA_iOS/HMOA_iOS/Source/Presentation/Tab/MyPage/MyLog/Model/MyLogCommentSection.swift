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
    case liked(MyLogComment?)
    case perfume(MyLogComment?)
    case community(MyLogComment?)
}

struct MyLogCommentData: Equatable {
    var perfume: [MyLogComment]
    var community: [MyLogComment]
}

