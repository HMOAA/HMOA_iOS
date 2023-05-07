//
//  MyProfileViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

class MyProfileViewController: UIViewController, View {
    
    lazy var myProfileReactor = MyProfileReactor()
        
    var disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MyProfileSection>!

    // MARK: - UI Component
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageSeparatorLineView.self, forHeaderFooterViewReuseIdentifier: MyPageSeparatorLineView.ientfifier)
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackItemNaviBar("내 정보")
        configureUI()
        bind(reactor: myProfileReactor)
    }
}

extension MyProfileViewController {
    
    // MARK: - Bind

    func bind(reactor: MyProfileReactor) {
        configureDataSource()
        
        // MARK: - action
        
        tableView.rx.itemSelected
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - state
        
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: {
                self.navigationController?.pushViewController($0, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    
    func configureUI() {
        
        view.addSubview(tableView)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<MyProfileSection> (configureCell: { _, tableView, indexPath, item in
            
            switch item {
            case .nickname(let nickname):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                    
                cell.updateCell(nickname)
                cell.selectionStyle = .none
                
                return cell
            case .year(let year):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                        
                cell.updateCell(year)
                cell.selectionStyle = .none
                
                return cell
            case .sex(let sex):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                        
                cell.updateCell(sex)
                cell.selectionStyle = .none
                
                return cell
            }
        })
    }
}


extension MyProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageSeparatorLineView.ientfifier)
        
        return footer
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}

