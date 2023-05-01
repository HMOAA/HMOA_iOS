//
//  Address.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

enum Address {
    case perfumeOne(Int) // 향수 1개 데이터 받아오기
    case postToken
    case checkNickname
    case patchNickname
    case patchSex
    case patchAge
    case patchJoin
}

extension Address {
    var url: String {
        switch self {
        case .perfumeOne(let perfumeId):
            return "perfumeId/\(perfumeId)"
        case .postToken:
            return "login/oauth2/GOOGLE"
        case .checkNickname:
            return "member/existsnickname"
        case .patchNickname:
            return "member/nickname"
        case .patchSex:
            return "member/sex"
        case .patchAge:
            return "member/age"
        case .patchJoin:
            return "member/join"
        }
    }
}

// 임시로 작성
struct Object: Codable {
    var test: String
}
