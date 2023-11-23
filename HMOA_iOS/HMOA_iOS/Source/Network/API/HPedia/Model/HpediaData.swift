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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode([HpediaTerm].self, forKey: .data)
        }
        catch {
            let res = try container.decode(HpediaTerm.self, forKey: .data)
            data = [res]
        }
    }
}

struct HpediaTerm: Hashable, Codable, HPediaItemConvertible {
    let termId: Int
    let termTitle: String
    let termEnglishTitle: String
    let content: String?
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: termId, title: termTitle, subTitle: termEnglishTitle, content: content)
    }
}

struct HpediaNoteResponse: Hashable, Codable {
    let data: [HpediaNote]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode([HpediaNote].self, forKey: .data)
        }
        catch {
            let res = try container.decode(HpediaNote.self, forKey: .data)
            data = [res]
        }
    }
}

struct HpediaNote: Hashable, Codable, HPediaItemConvertible {
    let noteId: Int
    let noteTitle: String
    let noteSubTitle: String
    let content: String?
    
    enum CodingKeys: String, CodingKey {
        case noteId, noteTitle, content
        case noteSubTitle = "noteSubtitle"
    }
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: noteId, title: noteTitle, subTitle: noteSubTitle, content: content)
    }
}

struct HpediaPerfumerResponse: Hashable, Codable {
    let data: [HpediaPerfumer]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode([HpediaPerfumer].self, forKey: .data)
        }
        catch {
            let res = try container.decode(HpediaPerfumer.self, forKey: .data)
            data = [res]
        }
    }
}

struct HpediaPerfumer: Hashable, Codable, HPediaItemConvertible {
    let perfumerId: Int
    let perfumerTitle: String
    let perfumerSubTitle: String
    let content: String?
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: perfumerId, title: perfumerTitle, subTitle: perfumerSubTitle, content: content)
    }
}

//TODO: - Brand dto 확인
struct HpediaBrandResponse: Hashable, Codable {
    let data: [HpediaBrand]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode([HpediaBrand].self, forKey: .data)
        }
        catch {
            let res = try container.decode(HpediaBrand.self, forKey: .data)
            data = [res]
        }
    }
}

struct HpediaBrand: Hashable, Codable, HPediaItemConvertible {
    let brandId: Int
    let brandTitle: String
    let brandSubTitle: String
    let content: String?
    
    func toHPediaItem() -> HPediaItem {
        return HPediaItem(id: brandId, title: brandTitle, subTitle: brandSubTitle, content: content)
    }
}

struct HPediaItem {
    let id: Int
    let title: String
    let subTitle: String
    let content: String?
}

