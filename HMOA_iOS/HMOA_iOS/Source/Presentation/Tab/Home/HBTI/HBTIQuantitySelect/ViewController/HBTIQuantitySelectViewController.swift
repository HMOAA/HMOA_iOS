//
//  HBTIQuantitySelectViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/16/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import ReactorKit

final class HBTIQuantitySelectViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let hbtiQuantityTopView = HBTIQuantitySelectTopView()
    
    private lazy var hbtiQuantityTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(HBTIQuantitySelectCell.self, forCellReuseIdentifier: HBTIQuantitySelectCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton()
    
    private let quantities = ["2개", "5개", "8개", "자유롭게 선택"]
    
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
         hbtiQuantityTopView,
         hbtiQuantityTableView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        hbtiQuantityTopView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(208)
        }
        
        hbtiQuantityTableView.snp.makeConstraints {
            $0.top.equalTo(hbtiQuantityTopView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(4 * 66)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
}

extension HBTIQuantitySelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quantities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HBTIQuantitySelectCell.reuseIdentifier, for: indexPath) as! HBTIQuantitySelectCell
        cell.configureCell(quantity: quantities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}

