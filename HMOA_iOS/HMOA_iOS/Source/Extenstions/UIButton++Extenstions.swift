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
    
    func makeLikeButton() {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 4.6, leading: 6, bottom: 4.6, trailing: 8)
        buttonConfig.imagePadding = 4
        buttonConfig.baseBackgroundColor = .customColor(.gray1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let normalImage = UIImage(named: "heart", in: .none, with: config)
        let selectedImage = UIImage(named: "heart_fill", in: .none, with: config)
        
        self.configuration = buttonConfig
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.tintColor = .black
        self.layer.cornerRadius = 10
        self.backgroundColor = .customColor(.gray1)
    }
}
