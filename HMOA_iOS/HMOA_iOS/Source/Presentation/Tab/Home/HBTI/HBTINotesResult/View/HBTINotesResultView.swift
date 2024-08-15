//
//  HBTINotesResultView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/6/24.
//

import UIKit
import SnapKit
import Then

class HBTINotesResultView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    
    private let titleLabel = UILabel().then {
        $0.text = "선택한 향료"
        $0.font = .customFont(.pretendard_bold, 20)
        $0.textColor = .black
    }
    
    private let totalPriceLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = .customFont(.pretendard_semibold, 18)
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        
    }
    
    private func setConstraints() {
        
    }
}
