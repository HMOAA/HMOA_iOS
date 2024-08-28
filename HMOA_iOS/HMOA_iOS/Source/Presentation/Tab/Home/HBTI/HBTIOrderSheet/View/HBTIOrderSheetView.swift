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
    
    private let dividingLineView1 = HBTIOrderDividingLineView()
    
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
         ordererInfoView,
         dividingLineView1
        ].forEach(addSubview)
    }
    
    // MARK: - Set Constraints
    
    private func setupConstraints() {
        ordererInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        dividingLineView1.snp.makeConstraints {
            $0.top.equalTo(ordererInfoView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
