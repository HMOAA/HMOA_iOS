
//
//  QnADetailSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//


enum QnADetailSection: Hashable {
    case qnaPost
    case comment
}

enum QnADetailSectionItem: Hashable {
    case qnaPostCell(CommunityDetail)
    case commentCell(CommunityComment?)
}

extension QnADetailSectionItem {
    
    var category: String {
        switch self {
        case .qnaPostCell(let detail):
            return detail.category
        default: return ""
        }
    }
}

struct CommunityDetailItems: Equatable {
    var postItem: [CommunityDetail]
    var commentItem: [CommunityComment]
}
