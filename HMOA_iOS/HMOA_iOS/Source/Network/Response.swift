//
//  Response\.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/20.
//

import Foundation


struct ErrorResponse: Codable {
    let code: String
    let message: String
}

struct NicknameResponse: Codable, Equatable{
    static func == (lhs: NicknameResponse, rhs: NicknameResponse) -> Bool {
        return lhs.data == rhs.data && lhs.message == rhs.message && lhs.resultCode == rhs.resultCode
    }
    
    let data: DataClass
    let message: String
    let resultCode: String
}

struct DataClass: Codable, Equatable {
    
}
