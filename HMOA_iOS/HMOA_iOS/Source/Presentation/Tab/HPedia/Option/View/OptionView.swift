//
//  OptionViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/10/09.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class OptionView: UIView, View {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 15
        $0.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifer)
    }
    
    lazy var cancleButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_medium, 20)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.setTitle("취소", for: .normal)
    }
    
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var buttonView = UIView()
    
    lazy var backgroundTapGesture = UITapGestureRecognizer()
    
    var parentVC: UIViewController? = nil
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetUp
    private func setUpUI() {
        self.isHidden = true
        backgroundView.addGestureRecognizer(backgroundTapGesture)
    }
    
    private func setAddView() {
        [
            tableView,
            cancleButton
        ]   .forEach { buttonView.addSubview($0) }
    
        [
            backgroundView,
            buttonView
        ]   .forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        cancleButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cancleButton.snp.top).offset(-8)
            make.height.equalTo(0)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
        
        
    }
    
    func bind(reactor: OptionReactor) {
        
        // Action
        
        cancleButton.rx.tap
            .map { Reactor.Action.didTapCancleButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 빈 화면 터치
        backgroundTapGesture.rx.event
            .map { _ in Reactor.Action.didTapBackgroundView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // TableView cell 터치
        tableView.rx.itemSelected
            .map { Reactor.Action.didTapOptionCell($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        // tableView binding
        reactor.state
            .map { $0.options }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items(cellIdentifier: OptionCell.identifer, cellType: OptionCell.self)) { index, item, cell in
                cell.updateCell(content: item)
            }
            .disposed(by: disposeBag)
        
        // tableview 개수에 따라 autoLayout 설정
        reactor.state
            .map { $0.options.count }
            .distinctUntilChanged()
            .filter { $0 != 0}
            .bind(with: self) { owner, count in
                owner.tableView.snp.updateConstraints { make in
                    make.height.equalTo(count * 60)
                }

                owner.buttonView.snp.updateConstraints { make in
                    let height = (count + 1) * 60 + 8
                    make.height.equalTo(height)
                    make.bottom.equalToSuperview().offset(height - 32)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 애니메이션 동작
        reactor.state
            .map { $0.isHiddenOptionView }
            .distinctUntilChanged()
            .bind(onNext: showAnimation)
            .disposed(by: disposeBag)
        
        // 수정 셀 터치
        reactor.state
            .map { $0.isTapEdit }
            .filter { $0 }
            .bind(with: self) { owner, _ in
                // 댓글 수정
                if reactor.currentState.type == "Comment" {
                    if let parentVC = owner.parentVC as? QnADetailViewController {
                        parentVC.presentCommentWirteViewControllerForWriter(.community(parentVC.reactor!))
                    }
                    
                    if let parentVC = owner.parentVC as? CommentListViewController {
                        parentVC.presentCommentWirteViewControllerForWriter(.commentList(parentVC.reactor!))
                    }
                    
                    if let parentVC = owner.parentVC as? DetailViewController {
                        parentVC.presentCommentWirteViewControllerForWriter(.perfumeDetail(parentVC.reactor!))
                    }
                }
                
                if reactor.currentState.type == "Post" {
                    let parentVC = owner.parentVC as! QnADetailViewController
                    parentVC.presentQnAWriteVCForEdit(reactor: parentVC.reactor!)
                }
            }.disposed(by: disposeBag)
    }

}

extension OptionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func showAnimation(_ isHidden: Bool) {
        
        let count = reactor!.currentState.options.count
        
        var buttonViewHeight: CGFloat = 0
        
        if count != 0 {
            buttonViewHeight = CGFloat((count + 1) * 60 + 8)
        }
        // 숨기기
        if isHidden {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = .clear
                self.buttonView.transform = .identity
            }) { _ in
                self.isHidden = true
            }
        }
        // 보이기
        else {
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.3)

                self.buttonView.transform = CGAffineTransform(translationX: 0, y: -buttonViewHeight)
            }) { _ in
                self.backgroundView.isHidden = false
            }
        }
    }
}
