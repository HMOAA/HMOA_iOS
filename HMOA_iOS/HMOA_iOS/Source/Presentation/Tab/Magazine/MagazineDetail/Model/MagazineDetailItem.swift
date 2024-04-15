//
//  MagazineDetailItem.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/19/24.
//

import Foundation

enum MagazineDetailSection: Hashable {
    case info
    case content
    case tags
    case like
    case magazineList
}

enum MagazineDetailItem: Hashable, Codable {
    case info(MagazineInfo)
    case magazineContent(MagazineContent)
    case magazineTag(MagazineTag)
    case like(MagazineLike)
    case magazineList(Magazine)
}

extension MagazineDetailItem {
    var info: MagazineInfo? {
        if case .info(let magazineInfo) = self {
            return magazineInfo
        } else {
            return nil
        }
    }
    
    var contents: MagazineContent? {
        if case .magazineContent(let magazineContent) = self {
            return magazineContent
        } else {
            return nil
        }
    }
    
    var tag: MagazineTag? {
        if case .magazineTag(let magazineTag) = self {
            return magazineTag
        } else {
            return nil
        }
    }
    
    var like: MagazineLike? {
        if case .like(let magazineLike) = self {
            return magazineLike
        } else {
            return nil
        }
    }
    
    var anotherMagazine: Magazine? {
        if case .magazineList(let magazine) = self {
            return magazine
        } else {
            return nil
        }
    }
    
    // initial snapshot items
    static let magazineInfo: MagazineDetailItem = .info(MagazineInfo(title: "제목", releasedDate: "발행일", viewCount: 123, previewImageURL: "이미지url", description: "소개글"))
    
    static let magazineContents: [MagazineDetailItem] = [
        .magazineContent(MagazineContent(type: "header", data: "헤더")),
        .magazineContent(MagazineContent(type: "content", data: "내용")),
        .magazineContent(MagazineContent(type: "image", data: "이미지")),
        .magazineContent(MagazineContent(type: "content", data: "내용2"))
    ]
    
    static let magazineTags: [MagazineDetailItem] = [
        .magazineTag(MagazineTag(tag: "태그1")),
        .magazineTag(MagazineTag(tag: "태애그2")),
        .magazineTag(MagazineTag(tag: "기이이이이이인태그3")),
        .magazineTag(MagazineTag(tag: "태그으으4")),
        .magazineTag(MagazineTag(tag: "기이인태그5"))
    ]
    
    static let magazineLike: MagazineDetailItem = .like(MagazineLike(id: 2, isLiked: false ,likeCount: 1234))
    
    static let otherMagazines: [MagazineDetailItem] = [
        .magazineList(Magazine(magazineID: 123, title: "제목1", description: "소개1", previewImageURL: "이미지 url1")),
        .magazineList(Magazine(magazineID: 234, title: "제목2", description: "소개2", previewImageURL: "이미지 url2")),
        .magazineList(Magazine(magazineID: 345, title: "제목3", description: "소개3", previewImageURL: "이미지 url3")),
        .magazineList(Magazine(magazineID: 456, title: "제목4", description: "소개4", previewImageURL: "이미지 url4"))
    ]
}
