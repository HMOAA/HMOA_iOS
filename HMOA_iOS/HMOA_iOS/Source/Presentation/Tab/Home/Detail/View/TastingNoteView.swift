//
//  TastingNoteView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class TastingNoteView: UIView {
    
    // MARK: - Properties
    
    
    lazy var noteImageView = UIImageView().then {
        $0.clipsToBounds = true
    }
    
    lazy var noteLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 12, color: .white)
    }

    lazy var lineView = UIView().then {
        $0.backgroundColor = UIColor.customColor(.gray2)
    }
    
    lazy var posLabel = UILabel().then {
        $0.textAlignment = .right
        $0.numberOfLines = 2
        $0.setLabelUI("", font: .pretendard_medium, size: 12, color: .black)
    }
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TastingNoteView {
    
    func configureUI() {
        [   noteImageView,
            lineView,
            posLabel    ]   .forEach { addSubview($0) }
        
        noteImageView.addSubview(noteLabel)
        
        noteImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(180)
        }
        
        noteLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(noteImageView.snp.trailing).offset(6)
            $0.height.equalTo(1)
            $0.width.greaterThanOrEqualTo(6)
        }
        
        posLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lineView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(32)
        }
    }
}
