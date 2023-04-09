//
//  HPediaGuideHeaderCell.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/04/09.
//

import UIKit

import Then
import TagListView
import SnapKit


class HPediaGuideHeaderCell: UICollectionReusableView {
    
    static let identifier = "HPediaGuideHeaderCell"
    
    //MARK: - Properties
    let guideLabel = UILabel().then {
        $0.setLabelUI("오늘의 지식", font: .pretendard_medium, size: 16, color: .black)
    }
    
    let guideViewAllButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitle("전체보기", for: .normal)
    }
    
    //MARK: - LifeCycle
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
        [
            guideLabel,
            guideViewAllButton
        ]  .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        
        guideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        guideViewAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
 
