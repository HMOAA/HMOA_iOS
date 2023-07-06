//
//  ListSecton.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import Foundation


enum ListSection {
    case main
}

struct ListSectionItem: Hashable {
    let id: Int
    let imgName: String
}

extension ListSectionItem {
    static let items: [ListSectionItem] = [
        ListSectionItem(id: 1, imgName: "jomalon"),
        ListSectionItem(id: 2, imgName: "jomalon"),
        ListSectionItem(id: 3, imgName: "jomalon"),
        ListSectionItem(id: 4, imgName: "jomalon"),
        ListSectionItem(id: 5, imgName: "jomalon"),
        ListSectionItem(id: 6, imgName: "jomalon"),
        ListSectionItem(id: 7, imgName: "jomalon"),
        ListSectionItem(id: 8, imgName: "jomalon"),
        ListSectionItem(id: 9, imgName: "jomalon"),
        ListSectionItem(id: 10, imgName: "jomalon"),
        ListSectionItem(id: 11, imgName: "jomalon"),
        ListSectionItem(id: 12, imgName: "jomalon"),
        ListSectionItem(id: 13, imgName: "jomalon"),
        ListSectionItem(id: 14, imgName: "jomalon"),
        ListSectionItem(id: 15, imgName: "jomalon"),
        ListSectionItem(id: 16, imgName: "jomalon"),
        ListSectionItem(id: 17, imgName: "jomalon"),
        ListSectionItem(id: 18, imgName: "jomalon"),
        ListSectionItem(id: 19, imgName: "jomalon"),
        ListSectionItem(id: 20, imgName: "jomalon"),
        ListSectionItem(id: 21, imgName: "jomalon"),
        ListSectionItem(id: 22, imgName: "jomalon"),
        ListSectionItem(id: 23, imgName: "jomalon"),
        ListSectionItem(id: 24, imgName: "jomalon"),
        ListSectionItem(id: 25, imgName: "jomalon"),
        ListSectionItem(id: 26, imgName: "jomalon"),
        ListSectionItem(id: 27, imgName: "jomalon"),
        ListSectionItem(id: 28, imgName: "jomalon")
    ]
}
