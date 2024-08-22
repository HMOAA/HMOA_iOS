//
//  HBTIModel.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/14/24.
//

import Foundation

struct HBTISurveyResponse: Hashable, Codable {
    let title: String
    let questions: [HBTIQuestion]
}

struct HBTIQuestion: Hashable, Codable {
    let id: Int
    let content: String
    let answers: [HBTIAnswer]
    let isMultipleChoice: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "questionId"
        case content
        case answers
        case isMultipleChoice
    }
}

struct HBTIAnswer: Hashable, Codable {
    let id: Int
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "optionId"
        case content = "option"
    }
}

struct HBTISurveyResultResponse: Hashable, Codable {
    let recommendNotes: [HBTISurveyResultNote]
}

struct HBTISurveyResultNote: Hashable, Codable {
    let id: Int
    let name: String
    let photoURL: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "noteId"
        case name = "noteName"
        case photoURL = "notePhotoUrl"
        case content
    }
}
