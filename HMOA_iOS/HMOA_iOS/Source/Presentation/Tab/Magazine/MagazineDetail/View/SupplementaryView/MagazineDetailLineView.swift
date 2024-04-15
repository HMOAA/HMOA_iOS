//
//  MagazineDetailLineView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/20/24.
//

import UIKit
import Then
import SnapKit

class MagazineDetailLineView: UICollectionReusableView {
    
    static let identifier = "MagazineDetailLineView"
    
    // 화면 스케일에 따른 1픽셀 라인 높이 계산
    private let lineHeight = 1 / UIScreen.main.scale
    
    private let lineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(lineHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor) {
        lineView.backgroundColor = color
    }
    
}
