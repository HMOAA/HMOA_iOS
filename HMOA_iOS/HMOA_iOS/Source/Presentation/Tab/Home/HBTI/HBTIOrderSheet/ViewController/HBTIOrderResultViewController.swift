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
    
    private lazy var goToHomeButton = UIButton().makeValidHBTINextButton(title: "홈으로 돌아가기").then {
        $0.addTarget(self, action: #selector(popToHBTIViewController), for: .touchUpInside)
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
    
    // MARK: Set UI
   
    private func setUI() {
        view.backgroundColor = .white
        setNaviBar("결제완료")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         orderIconMessageView,
         goToHomeButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        orderIconMessageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        goToHomeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
