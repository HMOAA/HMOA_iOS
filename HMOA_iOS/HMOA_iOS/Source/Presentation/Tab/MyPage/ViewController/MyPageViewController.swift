//
//  MyPageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import RxAppState

class MyPageViewController: UIViewController, View {

    var reactor: MyPageReactor
    var disposeBag = DisposeBag()

    // MARK: - UI Component
    let myPageView = MyPageView()

    var dataSource: RxTableViewSectionedReloadDataSource<MyPageSection>!
    
    init(reactor: MyPageReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigationBarTitle(title: "마이페이지", color: UIColor.white, isHidden: true)
        bind(reactor: reactor)
    }
}

// MARK: - Functions

extension MyPageViewController {
    
    func bind(reactor: MyPageReactor) {
        configureDataSource()
    
        // MARK: - action
        
        // tableView 아이템 클릭
        myPageView.tableView.rx.itemSelected
            .compactMap {
                MyPageType(rawValue: "\($0.section)" + "\($0.row)")
            }
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        Observable.just(())
          .map { Reactor.Action.viewDidLoad }
          .bind(to: reactor.action)
          .disposed(by: self.disposeBag)
        
        // MARK: - state
        
        // tableView 바인딩
        reactor.state
            .map { $0.sections }
            .bind(to: myPageView.tableView.rx.items(dataSource: dataSource))
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
    
    func configureUI() {
            
        view.addSubview(myPageView)
        
        myPageView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        myPageView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<MyPageSection>(configureCell: { _, tableView, indexPath, item in
            
            switch item {
            case .memberCell(let member):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageUserCell.identifier, for: indexPath) as? MyPageUserCell else { return UITableViewCell() }
                
                cell.updateCell(member)
                cell.selectionStyle = .none
                
                return cell
            case .otherCell(let title):
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
                
                cell.updateCell(title)
                cell.selectionStyle = .none

                return cell
            }
        })
    }
    
    func presentNextVC(_ type: MyPageType) {
        
        switch type {
        case .myLog:
            break
        case .myProfile:
            let myProfileReactor = reactor.reactorForMyProfile()
            let myProfileVC = MyProfileViewController(reactor: myProfileReactor)
            
            myProfileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myProfileVC, animated: true)
            
            print(reactor.currentState.member)
        case .openSource:
            break
        case .policy:
            break
        case .version:
            break
        case .logout:
            break
        case .deleteAccount:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 90
        } else {
            return 52
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 { return UIView() }
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageSeparatorLineView.ientfifier)

        return header
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}


