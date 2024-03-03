//
//  BackgroundDecorationView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 3/2/24.
//

import UIKit
import Then
import SnapKit

class BackgroundDecorationView: UICollectionReusableView {
        
    static let identifier = "BackgroundDecorationView"
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .random
    }
    
    private let blankSpaceView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .clear
    }
    
    private func setAddView() {
        [backgroundView, blankSpaceView].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        blankSpaceView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
    }
}
