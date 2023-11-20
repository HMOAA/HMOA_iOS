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
    case liked(Comment?)
    case perfume(Comment?)
    case community(CommunityComment?)
}

struct MyLogCommentData {
    var perfume: [Comment]
    var community: [CommunityComment]
}
