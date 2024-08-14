//
//  HBTIModel.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/14/24.
//

import Foundation

struct HBTISurveyResponse: Hashable {
    let title: String
    let questions: [HBTIQuestion]
}

struct HBTIQuestion: Hashable {
    let id: Int
    let content: String
    let answers: [HBTIAnswer]
}

struct HBTIAnswer: Hashable {
    let id: Int
    let content: String
}
