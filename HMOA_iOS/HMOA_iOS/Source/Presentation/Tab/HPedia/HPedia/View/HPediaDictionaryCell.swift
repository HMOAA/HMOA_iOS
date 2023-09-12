//
//  HPediaDictionaryCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/04.
//

import UIKit

import Then
import SnapKit
import ReactorKit

class HPediaDictionaryCell: UICollectionViewCell {
    
    static let identifier = "HPediaDictionaryCell"
    
    //MARK: - UIComponents
    let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_semibold, size: 16, color: .white)
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabelUI("", font: .pretendard, size: 16, color: .white)
    }
    
    //MARK: - Init
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
        self.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
    }
    private func setAddView() {
        [
            titleLabel,
            contentLabel
        ]   .forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(_ data: HPediaDictionaryData) {
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
}
