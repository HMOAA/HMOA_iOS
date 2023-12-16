//
//  ReportAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/25/23.
//

import Foundation

enum ReportAddress {
    case reportCommunity
    case reportCommunityComment
    case reportPerfumeComment
}

extension ReportAddress {
    var url: String {
        switch self {
        case .reportCommunity:
            return "report/community"
        case .reportCommunityComment:
            return "report/communityComment"
        case .reportPerfumeComment:
            return "report/perfumeComment"
            
        }
    }
}
