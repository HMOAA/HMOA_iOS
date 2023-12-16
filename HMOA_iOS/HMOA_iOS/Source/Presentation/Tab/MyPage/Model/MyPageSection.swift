//
//  MyPageSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//
import UIKit

enum MyPageSection {
    case memberSection(MyPageSectionItem)
    case pushAlarmSection(MyPageSectionItem)
    case otherSection([MyPageSectionItem])
}

enum MyPageSectionItem: Hashable{
    case memberCell(Member, UIImage?)
    case pushAlaramCell(String)
    case otherCell(String)
}

extension MyPageSection: Hashable {

    var items: [MyPageSectionItem] {
        switch self {
        case .memberSection(let item):
            return [item]
        case .pushAlarmSection(let item):
            return [item]
        case .otherSection(let items):
            return items
        }
    }
    
}
