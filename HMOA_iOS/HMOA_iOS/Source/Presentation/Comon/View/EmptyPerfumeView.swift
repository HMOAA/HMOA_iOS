//
//  EmptyPerfumeView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/11.
//

import UIKit
import SnapKit
import Then

class EmptyPerfumeView: UIView {
    
    // MARK: - Properties
    
    lazy var perfumeImageView1 = UIImageView().then {
        $0.image = UIImage(named: "emptyPerfume")
    }
    
    lazy var perfumeImageView2 = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "emptyPerfume")
    }
    
    lazy var perfumeImageView3 = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(named: "emptyPerfume")
    }
    
    lazy var capacityLabel1 = UILabel().then {
        $0.textColor = UIColor.customColor(.gray3)
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    lazy var capacityLabel2 = UILabel().then {
        $0.textColor = UIColor.customColor(.gray3)
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    lazy var capacityLabel3 = UILabel().then {
        $0.textColor = UIColor.customColor(.gray3)
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Functions
extension EmptyPerfumeView {
    
    func configureUI() {
        
        [   perfumeImageView1,
            perfumeImageView2,
            perfumeImageView3,
            capacityLabel1,
            capacityLabel2,
            capacityLabel3
        ] .forEach { addSubview($0) }
        
        
        perfumeImageView1.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(3)
            $0.top.equalToSuperview()
        }
        
        perfumeImageView2.snp.makeConstraints {
            $0.leading.equalTo(perfumeImageView1.snp.trailing).offset(16)
            $0.top.equalToSuperview()
        }
        
        perfumeImageView3.snp.makeConstraints {
            $0.leading.equalTo(perfumeImageView2.snp.trailing).offset(16)
            $0.top.equalToSuperview()
        }
        
        capacityLabel1.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView1.snp.bottom).offset(10)
            $0.centerX.equalTo(perfumeImageView1.snp.centerX)
        }
        
        capacityLabel2.snp.makeConstraints {
            $0.top.equalTo(capacityLabel1.snp.top)
            $0.centerX.equalTo(perfumeImageView2.snp.centerX)
        }
        
        capacityLabel3.snp.makeConstraints {
            $0.top.equalTo(capacityLabel1.snp.top)
            $0.centerX.equalTo(perfumeImageView3.snp.centerX)
        }
    }
}
