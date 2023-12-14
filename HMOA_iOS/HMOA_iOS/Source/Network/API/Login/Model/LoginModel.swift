//
//  LoginModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/15.
//

import Foundation


struct Token: Codable, Equatable {
    let authToken: String
    var existedMember: Bool?
    let rememberedToken: String
}


