//
//  QnADetailSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//


enum QnADetailSection: Hashable {
    case qnaPost([QnADetailSectionItem])
    case comment([QnADetailSectionItem])
}

enum QnADetailSectionItem: Hashable {
    case qnaPostCell(CommunityDetail)
    case commentCell(Comment)
}

extension QnADetailSection {
    
    var item: [QnADetailSectionItem] {
        switch self {
        case .qnaPost(let qnaPost):
            return qnaPost
        case .comment(let comment):
            return comment
        }
    }
}

struct QnAData: Hashable {
    let id: Int
    let nickname: String
    let day: Int
    let title: String
    let content: String
    let profileImageUrl: String?
}

