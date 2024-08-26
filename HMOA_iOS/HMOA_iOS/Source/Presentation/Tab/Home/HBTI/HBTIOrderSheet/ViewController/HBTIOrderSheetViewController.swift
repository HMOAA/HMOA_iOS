//
//  HBTIOrderSheetViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/25/24.
//

import UIKit
import SnapKit
import Then
import Bootpay

class HBTIOrderSheetViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let payButton = UIButton().then {
        $0.setTitle("결제하기", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }
    
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
    
    // MARK: - Functions
    
    private func setUI() {
        setBackItemNaviBar("주문서 작성")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         payButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        payButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
