//
//  Brand.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/17.
//

struct BrandList: Equatable, Hashable, Codable {
    var consonant: Int
    var brands: [Brand]
    
    enum CodingKeys: String, CodingKey {
        case consonant
        case brands = "brandList"
    }
}

struct Brand: Equatable, Hashable, Codable {
    let brandId: Int
    let brandImageUrl: String
    let brandName: String
    let englishName: String
}

extension BrandList {
    
    var section: BrandListSection? {
        switch self.consonant {
        case 1:
            return BrandListSection.first(self.brands.map { BrandCell.BrandItem($0) })
        case 2:
            return BrandListSection.second(self.brands.map { BrandCell.BrandItem($0) })
        case 3:
            return BrandListSection.third(self.brands.map { BrandCell.BrandItem($0) })

        case 4:
            return BrandListSection.fourth(self.brands.map { BrandCell.BrandItem($0) })
        case 5:
            return BrandListSection.fifth(self.brands.map { BrandCell.BrandItem($0) })
        case 6:
            return BrandListSection.sixth(self.brands.map { BrandCell.BrandItem($0) })
        case 7:
            return BrandListSection.seventh(self.brands.map { BrandCell.BrandItem($0) })
        case 8:
            return BrandListSection.eighth(self.brands.map { BrandCell.BrandItem($0) })
        case 9:
            return BrandListSection.ninth(self.brands.map { BrandCell.BrandItem($0) })
        case 10:
            return BrandListSection.tenth(self.brands.map { BrandCell.BrandItem($0)})
        case 11:
            return BrandListSection.eleventh(self.brands.map { BrandCell.BrandItem($0) })
        case 12:
            return BrandListSection.twelfth(self.brands.map { BrandCell.BrandItem($0) })
        case 13:
            return BrandListSection.thirteenth(self.brands.map { BrandCell.BrandItem($0) })
        case 14:
            return BrandListSection.fourtheenth(self.brands.map { BrandCell.BrandItem($0) })
        case 15:
            return BrandListSection.fifteen(self.brands.map { BrandCell.BrandItem($0) })
        default:
            return nil
        }
    }
}
