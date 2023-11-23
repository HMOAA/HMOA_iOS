//
//  HpediaData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import Foundation

protocol HPediaItemConvertible {
    func toHPediaItem() -> HPediaItem
}

struct HpediaTermResponse: Hashable, Codable {
    let data: [HpediaTerm]
}

struct HpediaTerm: Hashable, Codable, HPediaItemConvertible {
    let termId: Int
    let termTitle: String
    let termEnglishTitle: String
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: termId, title: termTitle, subTitle: termEnglishTitle)
    }
}

struct HpediaNoteResponse: Hashable, Codable {
    let data: [HpediaNote]
}

struct HpediaNote: Hashable, Codable, HPediaItemConvertible {
    let noteId: Int
    let noteTitle: String
    let noteSubTitle: String
    
    enum CodingKeys: String, CodingKey {
        case noteId, noteTitle
        case noteSubTitle = "noteSubtitle"
    }
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: noteId, title: noteTitle, subTitle: noteSubTitle)
    }
}

struct HpediaPerfumerResponse: Hashable, Codable {
    let data: [HpediaPerfumer]
}

struct HpediaPerfumer: Hashable, Codable, HPediaItemConvertible {
    let perfumerId: Int
    let perfumerTitle: String
    let perfumerSubTitle: String
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: perfumerId, title: perfumerTitle, subTitle: perfumerSubTitle)
    }
}

//TODO: - Brand dto 확인
struct HpediaBrandResponse: Hashable, Codable {
    let data: [HpediaBrand]
}

struct HpediaBrand: Hashable, Codable, HPediaItemConvertible {
    let brandId: Int
    let brandTitle: String
    let brandSubTitle: String
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: brandId, title: brandTitle, subTitle: brandSubTitle)
    }
}

struct HPediaItem {
    let id: Int
    let title: String
    let subTitle: String
}

