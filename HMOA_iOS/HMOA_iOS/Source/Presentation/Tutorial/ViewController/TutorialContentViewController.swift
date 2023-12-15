//
//  TutorialContentViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/15/23.
//

import UIKit

import Then
import SnapKit

class TutorialContentViewController: UIViewController {

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.setLabelUI("", font: .pretendard_medium, size: 20, color: .black)
    }
    
    let contentLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = #colorLiteral(red: 0.4756370187, green: 0.4756369591, blue: 0.4756369591, alpha: 1)
        $0.font = .customFont(.pretendard, 18)
    }
    
    let imageView = UIImageView()
    
    
    init(title: String, content: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        contentLabel.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593991637, alpha: 1)
    }
    private func setAddView() {
        [
            titleLabel,
            contentLabel,
            imageView
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(104)
            make.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * 258/360)
            make.height.equalTo(UIScreen.main.bounds.height * 465/720)
        }
    }

}
