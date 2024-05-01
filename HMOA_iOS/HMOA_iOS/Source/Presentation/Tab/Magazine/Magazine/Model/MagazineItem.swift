//
//  MagazineItem.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import Foundation

enum MagazineSection: Hashable {
    case mainBanner
    case newPerfume
    case topReview
    case allMagazine
}

enum MagazineItem: Hashable, Codable {
    case magazine(Magazine)
    case newPerfume(NewPerfume)
    case topReview(TopReview)
}

extension MagazineItem {
    var magazine: Magazine? {
        if case .magazine(let magazine) = self {
            return magazine
        } else {
            return nil
        }
    }
    
    var newPerfume: NewPerfume? {
        if case .newPerfume(let newPerfume) = self {
            return newPerfume
        } else {
            return nil
        }
    }
    
    var topReview: TopReview? {
        if case .topReview(let topReview) = self {
            return topReview
        } else {
            return nil
        }
    }
}
