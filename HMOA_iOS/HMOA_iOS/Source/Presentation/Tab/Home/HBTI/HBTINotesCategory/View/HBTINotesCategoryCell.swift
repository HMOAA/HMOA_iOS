//
//  HBTINotesCategoryCell.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesCategoryCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Components
        
    private let categoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.isUserInteractionEnabled = false
    }
    
    // MARK: - Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
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
    
    func configureCell(with notes: [HBTINotesCategoryData], selectedNote: [Int]) {
        categoryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        notes.forEach { note in
            let button = HBTINotesCategoryButton()
            let isSelected = selectedNote.contains(note.id)
            let selectionIndex = selectedNote.firstIndex(of: note.id)
            
            button.configureButton(with: note)
            button.setOverlayVisible(isSelected)
            button.setSelectionIndexLabel(selectionIndex, isSelected)
            
            button.snp.makeConstraints {
                $0.height.equalTo(134)
            }
            
            categoryStackView.addArrangedSubview(button)
        }
    }
}
