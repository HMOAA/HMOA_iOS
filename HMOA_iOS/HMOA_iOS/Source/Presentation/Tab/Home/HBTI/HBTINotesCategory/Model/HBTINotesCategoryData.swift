//
//  HBTINotesCategoryData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import Foundation

struct HBTINotesCategoryData {
    let titleLabelText = """
                         추천받은 카테고리는 '시트러스' 입니다.
                         원하는 카테고리 배송 수량을
                         선택해주세요
                         """

    let descriptionLabelText = "· 향료 1개 당 990원"
    
    let id: Int
    let title: String
    let image: String
    let description: String
}

extension HBTINotesCategoryData {
    static let data = [
        HBTINotesCategoryData(id: 1, title: "프루트", image: "Musk", description: "피치, 블랙베리,\n블랙체리\n(총 3,600원)"),
        HBTINotesCategoryData(id: 2, title: "아쿠아", image: "Musk", description: "씨 솔트\n(총 3,600원)\n"),
        HBTINotesCategoryData(id: 3, title: "스위트", image: "Musk", description: "허니, 바닐라,\n프랄린\n(총 4,800원)"),
        HBTINotesCategoryData(id: 4, title: "스파이스", image: "Musk", description: "넛맥, 블랙페퍼\n(총 3,600원)\n"),
        HBTINotesCategoryData(id: 5, title: "머스크", image: "Sweet", description: "화이트 머스크, 코튼,\n앰버, 벤조인\n(총 4,800원)"),
        HBTINotesCategoryData(id: 6, title: "플로럴", image: "Sweet", description: "네롤리, 화이트 로즈,\n핑크 로즈\n(총 4,800원)"),
        HBTINotesCategoryData(id: 7, title: "시트러스", image: "Sweet", description: "라임 만다린, 베르가못,\n비터 오렌지, 자몽\n(총 6,000원)")
    ]
}


