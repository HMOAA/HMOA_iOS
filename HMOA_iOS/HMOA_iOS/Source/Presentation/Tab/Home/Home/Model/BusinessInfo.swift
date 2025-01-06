//
//  BusinessInfo.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 1/6/25.
//

struct BusinessInfo {
    let businessNumber: String
    let representativeName: String
    let privacyOfficer: String
    let salesLicense: String
    let address: String
    let customerCenter: String
}

extension BusinessInfo {
    static let businessInfo = BusinessInfo(
        businessNumber: "554-20-01858",
        representativeName: "박태성",
        privacyOfficer: "이종현",
        salesLicense: "제 2023-화성동탄-0976호",
        address: "화성시 동탄지성로11, 714-B03호",
        customerCenter: "070-8080-3309"
    )
}
