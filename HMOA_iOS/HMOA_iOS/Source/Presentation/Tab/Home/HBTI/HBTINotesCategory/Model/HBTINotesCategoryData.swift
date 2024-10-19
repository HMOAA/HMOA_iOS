//
//  HBTINotesCategoryData.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import Foundation

struct HBTINotesCategoryData: Hashable {
    let id: Int
    let title: String
    let image: String
    let description: String
}

extension HBTINotesCategoryData {
    static let data = [
        HBTINotesCategoryData(id: 1, title: "시트러스", image: "Citrus", description: "라임 만다린, 베르가못,\n비터 오렌지, 자몽\n(총 4,800원)"),
        HBTINotesCategoryData(id: 2, title: "우디", image: "Woody", description: "샌달우드, 시더우드,\n 베티버, 패츌리\n(총 4,800원)"),
        HBTINotesCategoryData(id: 3, title: "프루티", image: "Fruit", description: "그레이프, 블랙베리,\n블랙체리, 복숭아\n(총 3,600원)"),
        HBTINotesCategoryData(id: 4, title: "플로럴", image: "Floral", description: "쟈스민, 라벤더,핑크 로즈,\n 화이트 로즈, 바이올렛, 피오니\n(총 7,200원)"),
        HBTINotesCategoryData(id: 5, title: "머스크", image: "Musk", description: "화이트 머스크, 코튼,\n앰버, 벤조인\n(총 4,800원)"),
        HBTINotesCategoryData(id: 6, title: "그린", image: "Green", description: "오크모스,\n그린티, 허브\n(총 3,600원)"),
        HBTINotesCategoryData(id: 7, title: "단 향료", image: "Sweet", description: "허니, 바닐라,\n프랄린\n(총 3,600원)"),
        HBTINotesCategoryData(id: 8, title: "스파이시", image: "Spice", description: "통카빈, 카디멈, 넛맥,\n 시나몬, 핑크페퍼\n(총 7,200원)")
    ]
}

struct HBTICategoryLabelTexts {
    let noteName: String
    var titleLabelText: String {
         """
         추천받은 카테고리는 '\(noteName)' 입니다.
         그 외에 원하는 시향카드 카테고리를
         선택해주세요
         """
    }
    let descriptionLabelText = "· 향료 1개 당 990원"
}

enum HBTINotesCategorySection: Hashable {
    case category
}

enum HBTINotesCategoryItem: Hashable {
    case note(HBTINotesCategoryData)
}


