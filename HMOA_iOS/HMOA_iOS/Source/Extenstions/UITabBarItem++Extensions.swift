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
        imageInsets.bottom = -25
    }
}
