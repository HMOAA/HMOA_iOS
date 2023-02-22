//
//  CommentListBottomView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import UIKit
import SnapKit
import Then

class CommentListBottomView: UIView {
    
    // MARK: - UI Component
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = .black
    }
    
    lazy var commentButton: UIButton = {
       
        var config = UIButton.Configuration.plain()
        let attri = AttributedString.init("댓글작성")
        
        config.attributedTitle = attri
        config.attributedTitle?.font = .customFont(.pretendard_medium, 20)
        config.attributedTitle?.foregroundColor = .white
        config.titleAlignment = .trailing
        config.image = UIImage(named: "bottomComment")
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentListBottomView {
    
    func configureUI() {
        
        [   backgroundView,
            commentButton
        ]   .forEach { addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.centerX.equalToSuperview()
        }
    }
}
