//
//  Magazine.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/27/24.
//

import UIKit

struct Magazine: Hashable {
    let slogan: String
    let perfumeName: String
    let description: String
    let longDescription: String
    let releaseDate: String
    let content: String
    let liked: Bool
    let likeCount: Int
    
    let coverImage = UIColor.random
    
    init(slogan: String, perfumeName: String, description: String, longDescription: String, releaseDate: String, content: String, liked: Bool, likeCount: Int) {
        self.slogan = slogan
        self.perfumeName = perfumeName
        self.description = description
        self.longDescription = longDescription
        self.releaseDate = releaseDate
        self.content = content
        self.liked = liked
        self.likeCount = likeCount
    }
}

extension UIColor {
    static var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
