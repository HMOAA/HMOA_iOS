//
//  UITabBarItem++Extensions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/13.
//

import UIKit

extension UITabBarItem {
    
    func customTabBar(imageName: String) {
        image = UIImage(named: imageName)
        selectedImage = UIImage(named: imageName + "Selected")
        imageInsets.top = 16
        imageInsets.bottom = -20
        titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
    }
}
