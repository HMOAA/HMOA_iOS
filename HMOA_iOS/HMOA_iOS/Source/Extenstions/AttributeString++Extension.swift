//
//  AttributeString++Extension.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/14.
//

import Foundation

extension AttributedString {
    
    /// Button AttributeString 텍스트 설정
    /// - Parameter text: title
    func setButtonAttirbuteString(text: String, size: CGFloat, font: Fonts) -> AttributedString {
        var attri = AttributedString.init(text)
        attri.font = .customFont(font, size)
        
        return attri
    }
}
