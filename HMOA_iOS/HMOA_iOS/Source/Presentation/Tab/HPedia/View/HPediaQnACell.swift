//
//  HPediaQnACell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/05.
//

import UIKit

import ReactorKit

class HPediaQnACell: UICollectionViewCell{
    
    static let identifier = "HPediaQnACell"
    //MAKR: - Properties
    let categoryLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_medium, size: 14, color: .gray2)
    }
    
    let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 16, color: .black)
    }
    var isListCell: Bool = false {
        didSet {
            if !isListCell {
                layer.borderWidth = 1
                layer.borderColor = UIColor.customColor(.gray2).cgColor
                layer.cornerRadius = 10
            } else {
                layer.addBorder([.bottom], color: .customColor(.gray2), width: 1)
            }
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        backgroundColor = .white
    }
    
    private func setAddView() {
        self.addSubview(categoryLabel)
        self.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
        }
    }
    
    func configure(_ data: HPediaQnAData) {
        categoryLabel.text = data.category
        titleLabel.text = data.title
    }
}
