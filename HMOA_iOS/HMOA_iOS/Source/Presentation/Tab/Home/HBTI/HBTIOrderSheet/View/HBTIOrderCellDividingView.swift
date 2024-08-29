//
//  HBTIOrderCellDividingView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/30/24.
//

import UIKit
import SnapKit
import Then

final class HBTIOrderCellDividingView: UIView {
    
    private let cellSeperatorLine = UIView().then {
        $0.backgroundColor = .customColor(.gray1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.blue.cgColor
        
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddView() {
        addSubview(cellSeperatorLine)
    }
    
    private func setConstraints() {
        cellSeperatorLine.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
