//
//  EvaluationAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/14.
//

import Foundation

enum EvaluationAddres {
    case postWether(String)
    case postGender(String)
    case postAge(String)
}

extension EvaluationAddres {
    var url: String {
        switch self {
        case .postWether(let id):
            return "perfume/\(id)/weather"
        case .postGender(let id):
            return "perfume/\(id)/gender"
        case .postAge(let id):
            return "perfume/\(id)/age"
        }
    }
}
