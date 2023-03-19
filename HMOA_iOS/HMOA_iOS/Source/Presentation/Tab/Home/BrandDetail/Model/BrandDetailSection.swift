//
//  BrandDetailSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import RxDataSources

typealias BrandDetailModel = SectionModel<BrandDetailSection, BrandDetailSectionItem>

enum BrandDetailSection {
    case first
}

enum BrandDetailSectionItem {
    case perfumeList(Perfume)
}
