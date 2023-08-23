//
//  DetailAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/18.
//

import Foundation

enum DetailAddress {
    case fetchPerfumeDetail
}

extension DetailAddress {
    var url: String {
        switch self {
        case .fetchPerfumeDetail:
            return "perfume/"
        }
    }
}
