//
//  ChocieEmailViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/02/20.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class ChoiceEmailViewController: UIViewController {
    
    //MARK: - Property
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    let emailLabel = UILabel().then {
        $0.setLabelUI("이메일 도메인", font: .pretendard, size: 16, color: .black)
    }
    
    let emailTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(EmailCell.self, forCellReuseIdentifier: EmailCell.identifier)
    }

    let disposeBag = DisposeBag()
    let emailViewModel = ChocieEmailViewModel()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAddView()
        setConstraints()
        bind()
        
    }

    //MARK: - SetUp
    private func bind() {
        
        emailViewModel.emailOb
            .bind(to: emailTableView.rx.items(cellIdentifier: EmailCell.identifier, cellType: EmailCell.self)) {index, item, cell in
                cell.emailLabel.text = item
            }.disposed(by: disposeBag)
        
        emailTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.emailViewModel.selectedIndex.onNext(indexPath.item)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func setAddView() {
        [xButton, emailLabel, emailTableView].forEach { view.addSubview($0) }
        
        xButton.addTarget(self, action: #selector(didTapXButton(_: )), for: .touchUpInside)
    }
    
    private func setConstraints() {
        
        xButton.snp.makeConstraints { make in
            make.width.height.equalTo(12)
            make.top.equalToSuperview().inset(23)
            make.trailing.equalToSuperview().inset(22)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(17)
            make.leading.equalToSuperview().inset(38)
        }
        
        emailTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(38)
            make.trailing.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(31)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Function
    @objc func didTapXButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
