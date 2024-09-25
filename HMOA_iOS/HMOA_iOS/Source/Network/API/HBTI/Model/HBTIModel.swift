//
//  HBTIModel.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/14/24.
//

import Foundation

// TODO: Model 파일 분리?

// 1차 전반부 (향BTI 결과까지)
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

// 2차 (배송 후 향수 추천)
struct HBTIPerfumeServeyResponse: Hashable, Codable {
    let priceQuestion: HBTIQuestion
    let noteQuestion: HBTINoteQuestion
}

struct HBTINoteQuestion: Hashable, Codable {
    let content: String
    let isMultipleChoice: Bool
    let answer: [HBTINoteAnswer]
}

struct HBTINoteAnswer: Hashable, Codable {
    let category: String
    let notes: [String]
}

struct HBTIPerfumeResultResponse: Hashable, Codable {
    let perfumeList: [HBTIPerfume]
    
    enum CodingKeys: String, CodingKey {
        case perfumeList = "recommendPerfumes"
    }
}

struct HBTIPerfume: Hashable, Codable {
    let id: Int
    let nameKR: String
    let nameEN: String
    let brand: String
    let price: Int
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "perfumeId"
        case nameKR = "perfumeName"
        case nameEN = "perfumeEnglishName"
        case brand = "brandName"
        case price
        case imageURL = "perfumeImageUrl"
    }
}
