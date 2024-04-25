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
}
