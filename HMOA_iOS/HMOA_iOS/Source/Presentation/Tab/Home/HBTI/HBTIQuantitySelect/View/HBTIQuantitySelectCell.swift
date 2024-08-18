//
//  HBTIQuantitySelectBottomView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/17/24.
//

import UIKit
import SnapKit
import Then

final class HBTIQuantitySelectCell: UICollectionViewCell {
    
    static let identifier = "HBTIQuantitySelectCell"
    
    // MARK: - UI Components
    
    private let answerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .equalSpacing
        $0.alignment = .fill
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
    
    // MARK: Set UI
    
    private func setUI() {
        
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        self.addSubview(answerStackView)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        answerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(quantities: [String]) {
        quantities.forEach {
            let button = HBTIQuantitySelectButton()
            button.quantityLabel.text = $0
            button.isSelected = false
            button.snp.makeConstraints {
                $0.height.equalTo(50)
            }
            answerStackView.addArrangedSubview(button)
        }
    }
}
