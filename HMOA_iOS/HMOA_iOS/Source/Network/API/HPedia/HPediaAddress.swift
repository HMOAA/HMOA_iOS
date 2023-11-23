//
//  HPediaAddress.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/23/23.
//

import Foundation

enum HPediaAddress {
    case fetchTermList
    case fetchNoteList
    case fetchPerfumerList
    case fetchBrandList
    case fetchTermDetail(String)
    case fetchNoteDetail(String)
    case fetchPerfumerDetail(String)
    case fetchBrandDetail(String)
}

extension HPediaAddress {
    var url: String {
        switch self {
        case .fetchTermList:
            return "term"
        case .fetchNoteList:
            return "note"
        case .fetchPerfumerList:
            return "perfumer"
        case .fetchBrandList:
            return "brandstory"
        case .fetchTermDetail(let id):
            return "term/\(id)"
        case .fetchNoteDetail(let id):
            return "note/\(id)"
        case .fetchPerfumerDetail(let id):
            return "perfumer/\(id)"
        case .fetchBrandDetail(let id):
            return "brand/\(id)"
        }
    }
}
