//
//  HBTIProcessGuideViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

final class HBTIProcessGuideViewController: UIViewController {
    
    // MARK: - UI Components
    private let hbtiProcessGuideView = HBTIProcessGuideView()
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton()
    
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
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         hbtiProcessGuideView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        hbtiProcessGuideView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(52)
        }
    }
}
