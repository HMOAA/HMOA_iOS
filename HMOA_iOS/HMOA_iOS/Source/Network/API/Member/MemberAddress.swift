//
//  MemberAddress.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/05/04.
//

import Foundation

enum MemberAddress {
    case checkNickname
    case patchNickname
    case patchSex
    case patchAge
    case patchJoin
    case member
    case uploadImage
    case fetchLikedComment
    case fetchPerfumeComment
    case fetchCommunityComment
    case fetchWritedPost
}

extension MemberAddress {
    var url: String {
        switch self {
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
        case .member:
            return "member"
        case .uploadImage:
            return "member/profile-photo"
        case .fetchLikedComment:
            return "member/hearts"
        case .fetchCommunityComment:
            return "member/communityComments"
        case .fetchPerfumeComment:
            return "member/perfumeComments"
        case .fetchWritedPost:
            return "member/communities"
        }
    }
}
