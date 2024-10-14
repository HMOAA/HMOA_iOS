//
//  OrderCategoryView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/24/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class OrderCategoryView: UIView {

    // MARK: - UI Components
    
    private let categoryImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .random
    }
    
    private let categoryLabel = UILabel().then {
        $0.setLabelUI("카테고리", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    private let noteListLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .black)
        $0.setTextWithLineHeight(text: "노트1, 노트2, 노트3, 노트4, 노트5, 노트6, 노트7", lineHeight: 12)
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
    private let quantityLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
        $0.setTextWithLineHeight(text: "수량 0개", lineHeight: 12)
    }
    
    private let unitPriceLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 10, color: .gray3)
        $0.setTextWithLineHeight(text: "000원/개", lineHeight: 12)
    }
    
    private let categoryPriceLabel = UILabel().then {
        $0.setLabelUI("0,000원", font: .pretendard_semibold, size: 14, color: .black)
    }
    
    // MARK: - Properties
    
    private let categoryImageWidth: CGFloat = 60
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setUI() {
        categoryImageView.layer.cornerRadius = categoryImageWidth / 2
    }
    
    private func setAddView() {
        [
            categoryImageView,
            categoryLabel,
            noteListLabel,
            quantityLabel,
            unitPriceLabel,
            categoryPriceLabel
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        categoryImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.width.equalTo(categoryImageWidth)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.top)
            make.leading.equalTo(categoryImageView.snp.trailing).offset(20)
        }
        
        noteListLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.leading.equalTo(categoryLabel.snp.leading)
            make.width.equalTo(170)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.leading.equalTo(noteListLabel.snp.leading)
            make.bottom.equalTo(categoryImageView.snp.bottom)
        }
        
        unitPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.top)
            make.leading.equalTo(quantityLabel.snp.trailing).offset(4)
        }
        
        categoryPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(unitPriceLabel.snp.bottom).offset(12)
            make.leading.equalTo(quantityLabel.snp.leading)
        }
    }
    
    func configureView(category: HBTICategory) {
        categoryImageView.kf.setImage(with: URL(string: category.imageURL))
        categoryLabel.text = category.name
        noteListLabel.text = category.noteList.map { $0.name }.joined(separator: ", ")
        quantityLabel.text = "수량 \(category.noteCount)개"
        unitPriceLabel.text = "\(category.price / category.noteCount)/개"
        categoryPriceLabel.text = category.price.numberFormatterToHangulWon()
    }
}
