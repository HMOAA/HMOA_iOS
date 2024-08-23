//
//  HBTINotesResultView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesResultCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
    
    private let containerView = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
        $0.layer.cornerRadius = 5
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_bold, 16)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.textColor = .black
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 14)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .customFont(.pretendard, 12)
        $0.textColor = .black
        $0.numberOfLines = 3
    }
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set UI
    
    private func setUI() {
        
    }
    
    // MARK: Add Views
    
    private func setAddView() {

    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        
    }
}
