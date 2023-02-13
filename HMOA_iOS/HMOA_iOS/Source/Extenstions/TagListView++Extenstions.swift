//
//  TagListView++Extenstions.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import TagListView
import UIKit

extension TagListView {
    
    func setDetailTagListView() {
        self.borderColor = .white
        self.cornerRadius = 15
        self.borderWidth = 0.2
        self.tagBackgroundColor = UIColor.customColor(.searchBarColor)
        self.textColor = .black
        self.alignment = .left
        self.textFont = UIFont.customFont(.pretendard, 12)
        self.paddingY = 8
        self.paddingX = 12
    }
}
