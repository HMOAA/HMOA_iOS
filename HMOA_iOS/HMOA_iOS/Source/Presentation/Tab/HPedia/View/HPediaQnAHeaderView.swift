//
//  HPediaQnAHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

import Then
import SnapKit

class HPediaQnAHeaderView: UICollectionReusableView {
    static let identifier = "HPediaQnAHeaderView"
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.setLabelUI("묻고 답하기", font: .pretendard, size: 16, color: .black)
    }
    
    let allButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard_light, 12)
        $0.setTitle("전체보기", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUp
    private func setAddView() {
        [
            titleLabel,
            allButton
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        allButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
}
