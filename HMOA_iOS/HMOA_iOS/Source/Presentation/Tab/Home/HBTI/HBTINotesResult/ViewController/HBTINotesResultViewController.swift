//
//  HBTINotesResultViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesResultViewController: UIViewController {
    
    // MARK: - UI Components
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: Set UI
    private func setUI() {
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    private func setAddView() {

    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        
    }
    
    // MARK: Create Layout
    
    // MARK: Configure DataSource
    
}
