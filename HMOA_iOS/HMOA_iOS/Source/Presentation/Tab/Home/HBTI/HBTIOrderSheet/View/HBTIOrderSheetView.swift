//
//  HBTIOrderSheetView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/26/24.
//

import UIKit

final class HBTIOrderSheetView: UIView {
    
    // MARK: - UI Components
    
    private let ordererInfoView = HBTIOrdererInfoView()
    
    // MARK: - Initialization
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setupConstraints()
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
         ordererInfoView
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setupConstraints() {
        ordererInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
