//
//  HBTINotesResultHeaderView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/24/24.
//

import UIKit
import SnapKit
import Then

class HBTINotesResultHeaderView: UIView {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 20)
        $0.textColor = .black
        $0.text = "선택한 향료 시향카드"
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        addSubview(titleLabel)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
