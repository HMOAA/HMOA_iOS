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
    case fifteen([BrandCell]) // ㄲ
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
    
    var items: [BrandCell] {
            switch self {
            case .first(let items):
                return items
            case .second(let items):
                return items
            case .third(let items):
                return items
            case .fourth(let items):
                return items
            case .fifth(let items):
                return items
            case .sixth(let items):
                return items
            case .seventh(let items):
                return items
            case .eighth(let items):
                return items
            case .ninth(let items):
                return items
            case .tenth(let items):
                return items
            case .eleventh(let items):
                return items
            case .twelfth(let items):
                return items
            case .thirteenth(let items):
                return items
            case .fourtheenth(let items):
                return items
            case .fifteen(let items):
                return items
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
        case .fifteen(_):
            return "ㄲ"
        }
    }
}

