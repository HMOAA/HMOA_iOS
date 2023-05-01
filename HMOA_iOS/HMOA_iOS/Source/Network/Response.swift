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
        return lhs.data == rhs.data &&
        lhs.message == rhs.message &&
        lhs.resultCode == rhs.resultCode
    }
    
    let data: DataClass
    let message: String
    let resultCode: String
}

struct JoinResponse: Codable, Equatable {
    
    static func == (lhs: JoinResponse, rhs: JoinResponse) -> Bool {
        return lhs.age == rhs.age &&
        lhs.nickname == rhs.nickname &&
        lhs.email == rhs.email &&
        lhs.imgUrl == rhs.imgUrl &&
        lhs.memberId == rhs.memberId &&
        lhs.sex == rhs.sex
    }
    
    let age: Int
    let email: String
    let imgUrl: String?
    let memberId: Int
    let nickname: String
    let sex: String
}

struct DataClass: Codable, Equatable {
    
}
