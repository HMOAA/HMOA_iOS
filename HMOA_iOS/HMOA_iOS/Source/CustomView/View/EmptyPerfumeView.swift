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
    
    lazy var perfumeImageView = UIImageView().then {
        $0.image = UIImage(named: "emptyPerfume")
    }
    
    lazy var capacityLabel = UILabel().then {
        $0.textColor = UIColor.customColor(.gray3)
        $0.font = UIFont.customFont(.pretendard, 12)
    }
    
    // MARK: - init
    
    init(_ capacity: String) {
        super.init(frame: .zero)
        self.capacityLabel.text = capacity
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Functions
extension EmptyPerfumeView {
    
    func configureUI() {
        
        [   perfumeImageView,
            capacityLabel   ] .forEach { addSubview($0) }
        
        
        perfumeImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        capacityLabel.snp.makeConstraints {
            $0.top.equalTo(perfumeImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
