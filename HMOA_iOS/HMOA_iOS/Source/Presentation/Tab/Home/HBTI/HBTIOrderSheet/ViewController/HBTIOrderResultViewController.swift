//
//  HBTIOrderResultViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 10/14/24.
//

import UIKit
import SnapKit
import Then

final class HBTIOrderResultViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let orderIconMessageView = IconMessageView(title: "결제가 완료 되었습니다.", iconWidth: 110)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind() {
        
        // MARK: Action
         
        // MARK: State

    }
    
    // MARK: Set UI
   
    private func setUI() {
        view.backgroundColor = .white
        setBackToHomeVCNaviBar("결제완료")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         orderIconMessageView
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        orderIconMessageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
