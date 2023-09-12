//
//  QnAWriteViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
class QnAWriteViewController: UIViewController {

    
    //MARK: - UI Components
    
    let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
        $0.textColor = .black
    }
    
    let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    let titleTextField = UITextField().then {
        $0.addLeftPadding(33)
        $0.placeholder = "제목"
        $0.setPlaceholder(color: .customColor(.gray3))
    }
    
    let textView = UITextView()
    
    //MARK: - Init
    init(title: String) {
        super .init(nibName: nil, bundle: nil)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleLabel)
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        titleTextField.layer.addBorder([.top, .bottom], color: .black, width: 1)
        
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    private func setAddView() {
        [
         titleTextField,
         textView
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.top.equalTo(titleTextField.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
    }
}
