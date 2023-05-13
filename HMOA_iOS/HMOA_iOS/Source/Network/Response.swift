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
    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.data == rhs.data
    }
    
    let data: DataClass
}

struct JoinResponse: Codable, Equatable {
    
    static func == (lhs: JoinResponse, rhs: JoinResponse) -> Bool {
        return lhs.age == rhs.age &&
        lhs.nickname == rhs.nickname &&
        lhs.imgUrl == rhs.imgUrl &&
        lhs.memberId == rhs.memberId &&
        lhs.provider == rhs.provider &&
        lhs.sex == rhs.sex
    }
    
    let age: Int
    let imgUrl: String?
    let memberId: Int
    let nickname: String
    let provider: String
    let sex: Bool
}

struct DataClass: Codable, Equatable {
    
}
