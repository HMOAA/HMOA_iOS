//
//  LoginModel.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/15.
//

import Foundation


struct GoogleToken: Codable, Equatable {
    let authToken: String
    let existedMember: Bool
    let rememberedToken: String
}


