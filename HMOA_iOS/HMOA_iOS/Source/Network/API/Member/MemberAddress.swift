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
    case fetchLikedPerfumeComment
    case fetchLikedCommunityComment
    case fetchPerfumeComment
    case fetchCommunityComment
    case fetchWritedPost
    case deleteMember
    case fetchOrder
    case fetchOrderCancel
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
        case .fetchLikedPerfumeComment:
            return "member/perfumeHearts"
        case .fetchLikedCommunityComment:
            return "member/communityHearts"
        case .fetchCommunityComment:
            return "member/communityComments"
        case .fetchPerfumeComment:
            return "member/perfumeComments"
        case .fetchWritedPost:
            return "member/communities"
        case .deleteMember:
            return "member/delete"
        case .fetchOrder:
            return "member/order"
        case .fetchOrderCancel:
            return "member/order/cancel"
        }
    }
}
