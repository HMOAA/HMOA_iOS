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
import ReactorKit

class MyProfileViewController: UIViewController, View {
    
    private var reactor: MyProfileReactor
    var disposeBag = DisposeBag()
    
    private var dataSource: UITableViewDiffableDataSource<MyProfileSection, MyProfileItem>!

    // MARK: - UI Component
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(MyPageSeparatorLineView.self, forHeaderFooterViewReuseIdentifier: MyPageSeparatorLineView.ientfifier)
        $0.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.identifier)
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 0
    }
    
    init(reactor: MyProfileReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackItemNaviBar("내 정보")
        configureUI()
        bind(reactor: reactor)
    }
}

extension MyProfileViewController {
    
    // MARK: - Bind

    func bind(reactor: MyProfileReactor) {
        configureDataSource()
        
        // MARK: - action
        
        // cell 선택
        tableView.rx.itemSelected
            .compactMap {
                MyProfileType(rawValue: $0.section)
            }
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: - state
        
        // tableView 바인딩
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, sections in
                var snapshot = NSDiffableDataSourceSnapshot<MyProfileSection, MyProfileItem>()
                
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot, animatingDifferences: false)
                }
            })
            .disposed(by: disposeBag)
        
        // cell 클릭 시 화면 전환
        reactor.state
            .map { $0.presentVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: {
                self.presentNextVC($0)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        
        view.addSubview(tableView)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<MyProfileSection, MyProfileItem>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            
            switch item {
            case .item(let title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                    
                cell.updateCell(title)
                cell.selectionStyle = .none
                
                return cell
            }
        })
    }
    
    private func presentNextVC(_ type: MyProfileType) {
        switch type {
        case .year:
            let changeYearReactor = reactor.reactorForChangeYear()
            
            let changeYearVC = ChangeYearViewConroller(reactor: changeYearReactor)
            self.navigationController?.pushViewController(changeYearVC, animated: true)
            
        case .sex:
            let changeSexVC = ChangeSexViewController()
            changeSexVC.reactor = reactor.reactorForChangeSex()
            
            self.navigationController?.pushViewController(changeSexVC, animated: true)
        }
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

