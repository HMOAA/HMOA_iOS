//
//  PhotoSection.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/11/01.
//

import UIKit

enum PhotoSection: Hashable {
    case photo
}

enum PhotoSectionItem: Hashable {
    case photoCell(UIImage)
}
