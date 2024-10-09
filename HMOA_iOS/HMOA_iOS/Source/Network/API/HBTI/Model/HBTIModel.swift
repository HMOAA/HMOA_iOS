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

// 1차 후반후, 3차
struct HBTICategoryListInfo: Codable, Hashable {
    let totalPrice: Int
    let categoryList: [HBTICategory]
    
    enum CodingKeys: String, CodingKey {
        case totalPrice
        case categoryList = "noteProducts"
    }
}

struct HBTICategory: Codable, Hashable {
    let id: Int
    let name: String
    let imageURL: String
    let noteCount: Int
    let noteList: [HBTINote]
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case name = "productName"
        case imageURL = "productPhotoUrl"
        case noteCount = "notesCount"
        case noteList = "notes"
        case price
    }
}

struct HBTINote: Codable, Hashable {
    let name: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case name = "noteName"
        case content = "noteContent"
    }
}
