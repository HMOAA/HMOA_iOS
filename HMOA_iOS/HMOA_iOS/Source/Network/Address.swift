//
//  Address.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

enum Address {
    case perfumeOne(Int) // 향수 1개 데이터 받아오기
}

extension Address {
    var url: String {
        switch self {
        case .perfumeOne(let perfumeId):
            return "perfumeId/\(perfumeId)"
        }
    }
}

// 임시로 작성
struct Object: Codable {
    var test: String
}
