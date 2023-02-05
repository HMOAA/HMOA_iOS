//
//  PerfumeInfoCell.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/05.
//

import UIKit
import SnapKit
import Then

class PerfumeInfoCell: UICollectionViewCell {
    
    // MARK: - identifier
    
    static let identifier = "PerfumeInfoCell"
    
    // MARK: - View
    
    let perfumeInfoView = PerfumeInfoView()
    let perfumeMiddleInfoView = PerfumeMiddleInfoView()
    
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

extension PerfumeInfoCell {
    
    func configureUI() {
        [   perfumeInfoView,
            perfumeMiddleInfoView   ] .forEach { addSubview($0) }
        
        perfumeInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(380)
        }
        
        perfumeMiddleInfoView.snp.makeConstraints {
            $0.top.equalTo(perfumeInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(430)
        }
    }
}
