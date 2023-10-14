//
//  MyLogViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import Then

class MyLogViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    // MARK: - UI Components
    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .none
    }
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
    }

    //MARK: - SetUp
    private func setUpUI() {
        self.setBackItemNaviBar("내 활동")
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: MyLogReactor) {
        
        
        // State
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // TableView Binding
        reactor.state
            .map { $0.item }
            .bind(to: tableView.rx.items(cellIdentifier: MyPageCell.identifier, cellType: MyPageCell.self)) { indexPath, item, cell in
                
                cell.contentView.layer.addBorder([.bottom], color: .customColor(.gray2), width: 2)
                cell.updateCell(item)
            }.disposed(by: disposeBag)
    }
}

extension MyLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 52
    }
}
