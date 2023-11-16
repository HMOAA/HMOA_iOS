//
//  CollectionViewCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 11/11/23.
//

import UIKit

import Then
import SnapKit
import Kingfisher

class QnAPostPhotoCell: UICollectionViewCell {
    
    static let identifier = "QnAPostPhotoCell"
    
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpUI()
    }
    
    //MARK: - SetUp
    
    private func setUpUI() {
        layer.addBorder([.bottom, .left, .right], color: .customColor(.gray2), width: 1)
    }
    private func setAddView() {
        [
            imageView
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(27)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    
}
