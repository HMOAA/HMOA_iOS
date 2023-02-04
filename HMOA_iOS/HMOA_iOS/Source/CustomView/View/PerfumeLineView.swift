//
//  PerfumeLineView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

class PerfumeLineView: UIView {
    
    lazy var lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var roundView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.cornerRadius = 5
    }
    
    lazy var infoLabel = UILabel().then {
        $0.font = UIFont.customFont(.pretendard, 16)
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions
extension PerfumeLineView {
    
    func configureUI() {
        [   lineView,
            roundView,
            infoLabel   ] .forEach { addSubview($0) }
        
        lineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(UIScreen.main.bounds.width - 180)
        }
        
        roundView.snp.makeConstraints {
            $0.leading.equalTo(lineView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(10)
        }
        
        infoLabel.snp.makeConstraints {
            $0.leading.equalTo(roundView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setLabel(label: String) {
        self.infoLabel.text = label
    }
}
