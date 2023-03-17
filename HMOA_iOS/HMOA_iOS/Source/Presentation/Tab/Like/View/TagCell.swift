//
//  TagCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/03/17.
//

import UIKit

import SnapKit
import Then

class TagCell: UICollectionViewCell {
    
    static let identifier = "TagCell"

    //MARK: - Property
    let tagView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.customColor(.gray3).cgColor
        $0.layer.cornerRadius = 10
    }
    let tagLabel = UILabel().then {
        $0.setLabelUI("",
                      font: .pretendard,
                      size: 10,
                      color: .gray3)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setAddView() {
        tagView.addSubview(tagLabel)
        contentView.addSubview(tagView)
    }
    
    private func setConstraints() {
        tagView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(18)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    

}
