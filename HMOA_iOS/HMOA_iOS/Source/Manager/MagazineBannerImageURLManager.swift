//
//  MagazineImageURLManager.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 4/19/24.
//

import Foundation

class MagazineBannerImageURLManager {
    static let shared = MagazineBannerImageURLManager()
    
    var imageURL: String? {
        didSet {
            NotificationCenter.default.post(name: .updateBackgroundImage, object: nil)
        }
    }
}
