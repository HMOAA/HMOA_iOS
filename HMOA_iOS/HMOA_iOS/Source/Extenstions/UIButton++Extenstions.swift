//
//  UIButton++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import UIKit

extension UIButton {
    
    func makeImageButton(_ image: UIImage) -> UIButton {
        let button = UIButton().then {
            $0.setImage(image, for: .normal)
            $0.tintColor = .black
        }
        
        return button
    }
}
