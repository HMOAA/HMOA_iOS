//
//  BrandSearchSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit
import RxDataSources

typealias BrandSectionModel = SectionModel<BrandListSection, BrandCell>
        
enum BrandListSection: Equatable {
    case first // ㄱ
    case second // ㄴ
    case third // ㄷ
    case fourth // ㄹ
    case five // ㅁ
}
    
enum BrandCell: Equatable {
    case BrandItem(Brand)
}

