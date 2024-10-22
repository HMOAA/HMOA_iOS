//
//  HBTIReviewList.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import Foundation

enum HBTIReviewListSection: Hashable {
    case review
}

enum HBTIReviewListItem: Hashable {
    case review(HBTIReview)
}

extension HBTIReviewListItem {
    var review: HBTIReview? {
        if case .review(let review) = self {
            return review
        } else {
            return nil
        }
    }
}
