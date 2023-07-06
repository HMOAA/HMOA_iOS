//
//  HPediaBrandData.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import Foundation

struct HPediaTagData: Hashable {
    var id: Int
    var name: String
}

extension HPediaTagData {
    static let list =
    [
        HPediaTagData(id: 1, name: "Chanel 샤넬"),
        HPediaTagData(id: 2, name: "Jo Malone London 조말론 런던"),
        HPediaTagData(id: 3, name: "Diptyque 딥티크"),
        HPediaTagData(id: 4, name: "Tom Ford 톰포드"),
        HPediaTagData(id: 5, name: "Cristian Dior 크리스챤 디올"),
        HPediaTagData(id: 6, name: "Chanel 샤넬"),
        HPediaTagData(id: 7, name: "Chanel 샤넬"),
        HPediaTagData(id: 8, name: "Chanel 샤넬")
    ]
}
