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

class OptionViewController: UIViewController, View {
    
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 15
        $0.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifer)
    }
    
    let cancleButton = UIButton().then {
        $0.titleLabel?.font = .customFont(.pretendard_medium, 20)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.setTitle("취소", for: .normal)
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let backgroundTapGesture = UITapGestureRecognizer()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        backgroundView.addGestureRecognizer(backgroundTapGesture)
    }
    
    private func setAddView() {
        view.addSubview(tableView)
        view.addSubview(cancleButton)
        view.addSubview(backgroundView)
    }
    
    private func setConstraints() {
        cancleButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(48)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(cancleButton.snp.top).offset(-8)
            make.height.equalTo((reactor?.currentState.options.count)! * 60)
            
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    func bind(reactor: OptionReactor) {
        
        backgroundTapGesture.rx.event
            .map { _ in Reactor.Action.didTapBackgroundView}
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.options }
            .bind(to: tableView.rx.items(cellIdentifier: OptionCell.identifer, cellType: OptionCell.self)) { index, item, cell in
                cell.updateCell(content: item)
            }
            .disposed(by: disposeBag)
    }

}

extension OptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
