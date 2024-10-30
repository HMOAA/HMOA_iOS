//
//  HBTIReviewCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

final class HBTIReviewCell: UICollectionViewCell {
    
    static let identifier = "HBTIReviewCell"
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    let reviewView = HBTIReviewView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Function
    
    private func setAddView() {
        [
            reviewView
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        reviewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCell(review: HBTIReview) {
        
    }
}

