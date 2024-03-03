//
//  NewPerfume.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 2/26/24.
//

import UIKit

struct NewPerfume: Hashable {
    let name: String
    let brand: String
    let releaseDate: String
    
    let color = UIColor.random
    
    init(name: String, brand: String, releaseDate: String) {
        self.name = name
        self.brand = brand
        self.releaseDate = releaseDate
    }
}
