
//
//  CommunityDetailSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//


enum CommunityDetailSection: Hashable {
    case post
    case comment
}

enum CommunityDetailSectionItem: Hashable {
    case postCell(CommunityDetail)
    case commentCell(CommunityComment?)
}

extension CommunityDetailSectionItem {
    
    var category: String {
        switch self {
        case .postCell(let detail):
            return detail.category
        default: return ""
        }
    }
}

struct CommunityDetailItems: Equatable {
    var postItem: [CommunityDetail]
    var commentItem: [CommunityComment?]
}
