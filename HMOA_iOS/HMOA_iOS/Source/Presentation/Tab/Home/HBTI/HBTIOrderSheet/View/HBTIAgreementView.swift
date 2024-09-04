//
//  HBTIAgreementView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 9/2/24.
//

import UIKit
import SnapKit
import Then

final class HBTIAgreementView: UIView {
    
    // MARK: - Properties
    
    private let agreementData: [HBTIAgreementModel] = HBTIAgreementModel.agreementData
    
    // MARK: - UI Components
    
    private lazy var agreementTableView = UITableView().then {
        $0.register(HBTIAgreementCell.self, forCellReuseIdentifier: HBTIAgreementCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setAddView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set UI

    private func setUI() {
        
    }

    // MARK: - Set AddView

    private func setAddView() {
        [
         agreementTableView
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        agreementTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension HBTIAgreementView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        agreementData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HBTIAgreementCell.reuseIdentifier, for: indexPath) as? HBTIAgreementCell else {
            return UITableViewCell()
        }
        
        let agreement = agreementData[indexPath.row]
        cell.configureCell(with: agreement)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
}
