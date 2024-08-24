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
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton()
    
    // MARK: - Properties
    
    private let selectedNotes: [HBTINotesResultModel]
    
    // MARK: - Initialization
    
    init(selectedNotes: [HBTINotesResultModel]) {
        self.selectedNotes = selectedNotes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        [
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
    
    // MARK: Configure DataSource
    
}
