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
        }
    }
}
