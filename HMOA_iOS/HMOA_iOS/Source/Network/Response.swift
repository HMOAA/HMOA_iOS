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

struct Response: Codable, Equatable{
    let data: DataClass
}

struct JoinResponse: Codable, Equatable {
    
    let age: Int
    let imgUrl: String?
    let memberId: Int
    let nickname: String
    let provider: String
    let sex: Bool
}

struct DataClass: Codable, Equatable {
    
}
