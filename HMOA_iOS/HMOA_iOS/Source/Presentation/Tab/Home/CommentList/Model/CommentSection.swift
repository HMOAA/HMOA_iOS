//
//  CommentSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit

enum CommentSection: Hashable {
    case comment
}

enum CommentSectionItem: Hashable {
    case commentCell(Comment)
}
