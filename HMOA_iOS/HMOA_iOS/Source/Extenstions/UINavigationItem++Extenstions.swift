//
//  UINavigationItem++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/14.
//

import UIKit

extension UINavigationItem {
    
    func makeButtonItem(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        
        let button = UIButton().then {
            $0.setImage(UIImage(named: imageName), for: .normal)
            $0.addTarget(target, action: action, for: .touchUpInside)
            $0.tintColor = .black
        }
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        barButtonItem.customView?.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return barButtonItem
    }
}
