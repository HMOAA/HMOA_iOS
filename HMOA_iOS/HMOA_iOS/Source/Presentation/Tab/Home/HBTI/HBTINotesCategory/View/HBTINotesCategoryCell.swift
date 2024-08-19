//
//  HBTINotesCategoryCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryCell: UICollectionViewCell {
    
    // MARK: - UI Components
        
    private let categoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    // MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
        
    private func setUI() {
        
    }
    
    // MARK: - Set AddView
    
    private func setAddView() {
        [
         categoryStackView
        ].forEach(contentView.addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        categoryStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Configuration
    
    func configureCell(with note: [HBTINotesCategoryData]) {
        note.forEach {
            let button = HBTINotesCategoryButton()
            button.configureButton(with: $0)
            button.snp.makeConstraints {
                $0.height.equalTo(134)
            }
            answerStackView.addArrangedSubview(button)
        }
    }
}
