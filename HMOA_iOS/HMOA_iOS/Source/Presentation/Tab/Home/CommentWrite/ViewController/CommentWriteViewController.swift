//
//  CommentWriteViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/22.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class CommentWriteViewController: UIViewController, View {
    typealias Reactor = CommentWriteReactor
    

    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component

    lazy var textField: UITextField = {
       let textField = UITextField()
        textField.font = .customFont(.pretendard, 14)
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.attributedPlaceholder = NSAttributedString(string: "해당 제품에 대한 의견을 남겨주세요")
        return textField
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    // MARK: - Objc func
    
    @objc func cancleButtonClicked() {
        self.popViewController()
    }
    
    @objc func okButtonClicked() {
        
    }
}

// MARK: - Functions

extension CommentWriteViewController {
    
    // MARK: - Bind
    func bind(reactor: CommentWriteReactor) {

    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        view.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(588)
        }
    }
    
    func configureNavigationBar() {
        let titleLabel = UILabel().then {
            $0.text = "댓글"
            $0.font = .customFont(.pretendard_medium, 20)
            $0.textColor = .black
        }
        
        let cancleButton = self.navigationItem.makeTextButtonItem(self, action: #selector(cancleButtonClicked), title: "취소")
        
        let okButton = self.navigationItem.makeTextButtonItem(self, action: #selector(okButtonClicked), title: "확인")
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItems = [cancleButton]
        self.navigationItem.rightBarButtonItems = [okButton]

    }
}
