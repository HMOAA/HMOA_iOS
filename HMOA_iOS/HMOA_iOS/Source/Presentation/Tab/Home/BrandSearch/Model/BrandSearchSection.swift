//
//  BrandSearchSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

import UIKit
import RxDataSources

enum BrandListSection {
    case first([BrandCell]) // ㄱ
    case second ([BrandCell])// ㄴ
    case third([BrandCell]) // ㄷ
    case fourth ([BrandCell])// ㄹ
    case fifth([BrandCell]) // ㅁ
    case sixth([BrandCell]) // ㅂ
    case seventh([BrandCell]) // ㅅ
    case eighth([BrandCell]) // ㅇ
    case ninth([BrandCell]) // ㅈ
    case tenth([BrandCell]) // ㅊ
    case eleventh([BrandCell]) // ㅋ
    case twelfth([BrandCell]) // ㅌ
    case thirteenth([BrandCell]) // ㅍ
    case fourtheenth([BrandCell]) // ㅎ
}

enum BrandCell {
    case BrandItem(Brand)
}

extension BrandCell: Hashable {
    
    var brand: Brand {
        switch self {
        case .BrandItem(let brand):
            return brand
        }
    }
}

extension BrandListSection: Hashable {
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .first(let brand):
            hasher.combine(brand)
        case .second(let brand):
            hasher.combine(brand)
        case .third(let brand):
            hasher.combine(brand)
        case .fourth(let brand):
            hasher.combine(brand)
        case .fifth(let brand):
            hasher.combine(brand)
        case .sixth(let brand):
            hasher.combine(brand)
        case .seventh(let brand):
            hasher.combine(brand)
        case .eighth(let brand):
            hasher.combine(brand)
        case .ninth(let brand):
            hasher.combine(brand)
        case .tenth(let brand):
            hasher.combine(brand)
        case .eleventh(let brand):
            hasher.combine(brand)
        case .twelfth(let brand):
            hasher.combine(brand)
        case .thirteenth(let brand):
            hasher.combine(brand)
        case .fourtheenth(let brand):
            hasher.combine(brand)
        }
    }
    
    
    var consonant: String {
        switch self {
        case .first(_):
            return "ㄱ"
        case .second(_):
            return "ㄴ"
        case .third(_):
            return "ㄷ"
        case .fourth(_):
            return "ㄹ"
        case .fifth(_):
            return "ㅁ"
        case .sixth(_):
            return "ㅂ"
        case .seventh(_):
            return "ㅅ"
        case .eighth(_):
            return "ㅇ"
        case .ninth(_):
            return "ㅈ"
        case .tenth(_):
            return "ㅊ"
        case .eleventh(_):
            return "ㅋ"
        case .twelfth(_):
            return "ㅌ"
        case .thirteenth(_):
            return "ㅍ"
        case .fourtheenth(_):
            return "ㅎ"
        }
    }
}

