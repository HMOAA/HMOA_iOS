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
    
    private let allAgreementData: HBTIAgreementModel = HBTIAgreementModel.allAgreementData
    private let partialAgreementData: [HBTIAgreementModel] = HBTIAgreementModel.partialAgreementData
    
    // MARK: - UI Components
    
    private lazy var allAgreementButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        
        // 텍스트 설정
        config.title = allAgreementData.agreementTitle
        config.baseForegroundColor = .black
        config.attributedTitle?.font = UIFont.customFont(.pretendard_bold, 14)
        
        // 이미지 설정
        config.imagePadding = 8
        config.image = UIImage(named: "checkBoxNotSelectedSvg")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        $0.titleLabel?.numberOfLines = 0
        $0.contentHorizontalAlignment = .leading
        $0.configuration = config
    }
    
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
         allAgreementButton,
         agreementTableView
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        allAgreementButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        agreementTableView.snp.makeConstraints {
            $0.top.equalTo(allAgreementButton.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview()
        }
    }
}

extension HBTIAgreementView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        partialAgreementData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HBTIAgreementCell.reuseIdentifier, for: indexPath) as? HBTIAgreementCell else {
            return UITableViewCell()
        }
        
        let agreement = partialAgreementData[indexPath.row]
        cell.configureCell(with: agreement)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //  셀 높이(12) + 셀 간격(16)
        return 28
    }
}
