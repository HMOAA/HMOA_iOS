//
//  String++Extension.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/06/04.
//

import Foundation

extension String {
    
    mutating func changeProvider() {

        switch self {
        case "GOOGLE":
            self =  "구글 로그인"
        case "KAKAO":
            self = "카카오 로그인"
        case "APPLE":
            self = "애플 로그인"
        default:
            self = ""
        }
    }
}
