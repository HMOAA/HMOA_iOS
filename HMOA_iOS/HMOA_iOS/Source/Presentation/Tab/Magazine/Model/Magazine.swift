//
//  Magazine.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/27/24.
//

import UIKit

struct Magazine: Hashable {
    // MARK: 표지 내용
    let slogan: String
    let perfumeName: String
    let description: String
    let longDescription: String
    
    let coverImage = UIColor.random
    
    init(slogan: String, perfumeName: String, description: String, longDescription: String) {
        self.slogan = slogan
        self.perfumeName = perfumeName
        self.description = description
        self.longDescription = longDescription
    }
}

extension UIColor {
    static var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
