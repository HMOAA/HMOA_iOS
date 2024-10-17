//
//  UIButton++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/23.
//

import UIKit

extension UIButton {
    
    func grayBorderButton(title: String) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .customFont(.pretendard_semibold, 12)
            $0.setTitleColor(.customColor(.gray3), for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.customColor(.gray3).cgColor
            $0.layer.cornerRadius = 3
        }
        
        return button
    }
    
    func makeFloatingListButton(title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init(title)
        titleAttr.font = .customFont(.pretendard, 16)
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "floatingCircle")
        config.imagePlacement = .leading
        config.imagePadding = 7
        config.titleAlignment = .leading
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }
    
    func makeImageButton(_ image: UIImage) -> UIButton {
        let button = UIButton().then {
            $0.setImage(image, for: .normal)
            $0.tintColor = .black
        }
        
        return button
    }
    
    func makeHeartButton() {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 4.6, leading: 6, bottom: 4.6, trailing: 8)
        buttonConfig.imagePadding = 4
        buttonConfig.baseBackgroundColor = .customColor(.gray1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let normalImage = UIImage(named: "emptyHeart", in: .none, with: config)
        let selectedImage = UIImage(named: "heart", in: .none, with: config)
        
        self.configuration = buttonConfig
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.tintColor = .black
        self.layer.cornerRadius = 10
        self.backgroundColor = .customColor(.gray1)
    }
    
    func makeLikeButton() {
        var buttonConfig = UIButton.Configuration.plain()
        
        buttonConfig.imagePadding = 5
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        buttonConfig.baseBackgroundColor = .white
        
        let normalImage = UIImage(named: "like")
        let selectedImage = normalImage?.withTintColor(.customColor(.red))
        
        self.configuration = buttonConfig
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.tintColor = .black
    }
    
    func makeCommentButton() {
        var buttonConfig = UIButton.Configuration.plain()

        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: 4.6, leading: 6, bottom: 4.6, trailing: 8)
        buttonConfig.imagePadding = 4
        buttonConfig.baseBackgroundColor = .customColor(.gray1)
        
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular, scale: .default)
        let normalImage = UIImage(named: "commentIcon", in: .none, with: config)
        
        self.configuration = buttonConfig
        self.setImage(normalImage, for: .normal)
        self.tintColor = .black
        self.layer.cornerRadius = 10
        self.backgroundColor = .customColor(.gray1)
    }
    
    func makeCategoryButton(_ title: String) {
        
        var selectedConfig = UIButton.Configuration.plain()
        var normalConfig = UIButton.Configuration.plain()
        var attribute = AttributedString.init(title)
        attribute.font = .customFont(.pretendard, 14)
                
        selectedConfig.baseBackgroundColor = .white
        selectedConfig.baseForegroundColor = .white
        normalConfig.baseForegroundColor = .customColor(.gray3)
        normalConfig.baseBackgroundColor = .white

        selectedConfig.attributedTitle = attribute
        normalConfig.attributedTitle = attribute
        
        self.configurationUpdateHandler = {
            switch $0.state {
            case .selected:
                $0.configuration = selectedConfig
                $0.backgroundColor = .black
            default:
                $0.configuration = normalConfig
                $0.backgroundColor = .white
                $0.layer.borderColor = UIColor.customColor(.gray3).cgColor
                $0.layer.borderWidth = 1
            }
        }
        
        self.layer.cornerRadius = 10
    }
    
    func setConfigButton(_ type: LoginType){
        
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init(type.title)
        titleAttr.font = .customFont(.pretendard_medium, 16)
        titleAttr.foregroundColor = type.color
        
        config.attributedTitle = titleAttr
        config.background.backgroundColor = type.backgroundColor
        
        config.image = type.image
        config.imagePadding = type.padding
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 48, bottom: 0, trailing: type.rightPadding)
        
        self.configuration = config
    }
    
    func setProfileChangeBottomView() {
        self.isEnabled = false
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .customColor(.gray2)
        self.titleLabel?.font = .customFont(.pretendard, 20)
        self.setTitle("변경", for: .normal)
    }
    
    func setHBTIPriorityButton(title: String) {
        self.setTitleColor(.init(hexCode: "9C9C9C"), for: .normal)
        self.setTitleColor(.black, for: .selected)
        self.titleLabel?.font = .customFont(.pretendard, 12)
        self.setTitle(title, for: .normal)
    }
    
    func makeValidHBTINextButton(title: String) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .customFont(.pretendard, 15)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .black
        }
        
        return button
    }
    
    func makeInvalidHBTINextButton() -> UIButton {
        let button = UIButton().then {
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .customFont(.pretendard, 15)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .customColor(.gray3)
        }

        return button
    }
}
