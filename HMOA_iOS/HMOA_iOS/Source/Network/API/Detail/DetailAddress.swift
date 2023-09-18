//
//  DetailAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/08/18.
//

import Foundation

enum DetailAddress {
    case fetchFirstPerfumeDetail
    case fetchSecondPErfumeDetail(String)
}

extension DetailAddress {
    var url: String {
        switch self {
        case .fetchFirstPerfumeDetail:
            return "perfume/"
        case .fetchSecondPErfumeDetail(let id):
            return "perfume/\(id)/2"
        }
    }
}
