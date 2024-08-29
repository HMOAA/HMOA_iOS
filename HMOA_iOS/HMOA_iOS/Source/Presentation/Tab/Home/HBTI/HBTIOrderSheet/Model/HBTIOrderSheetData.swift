//
//  HBTIOrderSheetData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import Foundation

struct HBTIOrderSheetData {
    let image: String
    let title: String
    let details: String
    let count: Int
    let price: Int
}

extension HBTIOrderSheetData {
    static let productData: [HBTIOrderSheetData] = [
        HBTIOrderSheetData(image: "Citrus", title: "시트러스", details: "라임 만다린, 베르가못, 비터 오렌지, 자몽", count: 4, price: 4800),
        HBTIOrderSheetData(image: "Floral", title: "플로럴", details: "네롤리, 화이트 로즈, 핑크 로즈, 화이트로즈, 바이올렛, 피오니", count: 6, price: 7200)
    ]
}
