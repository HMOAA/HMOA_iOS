//
//  HBTIPerfumeResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIPerfumeResultViewController: UIViewController, View {

    // MARK: - UI Components
    
    private var titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "고객님에게 어울릴 향수는", lineHeight: 27)
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    func bind(reactor: HBTIPerfumeResultReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향수 추천")
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            titleLabel
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

}
