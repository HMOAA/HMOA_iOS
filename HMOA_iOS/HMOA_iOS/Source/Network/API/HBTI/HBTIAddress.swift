//
//  HBTIAddress.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/20/24.
//

import Foundation

enum HBTIAddress {
    case fetchQuestionList
    
    var url: String {
        switch self {
        case .fetchQuestionList:
            return "survey/note"
        }
    }
}
