//
//  QnAPostHeaderView.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit

class QnAPostHeaderView: UICollectionReusableView {
    static let identifier = "QnAPostHeaderView"
    
    let recommendLabel = UILabel().then {
        $0.setLabelUI("추천해주세요", font: .pretendard_medium, size: 14, color: .gray2)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        //backgroundColor = .black
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAddView() {
        addSubview(recommendLabel)
    }
    
    func setConstraints() {
        recommendLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
