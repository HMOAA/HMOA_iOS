//
//  HBTINotesResultModel.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/23/24.
//

import Foundation

enum HBTINotesResultSection: Hashable {
    case notesResult
}

enum HBTINotesResultItem: Hashable {
    case notesResult(HBTICategory)
}

extension HBTINotesResultItem {
    var result: HBTICategory? {
        if case .notesResult(let result) = self {
            return result
        } else {
            return nil
        }
    }
}
