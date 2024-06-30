//
//  PushAlarmViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 6/17/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class PushAlarmViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private lazy var pushAlarmTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(PushAlarmCell.self, forCellReuseIdentifier: PushAlarmCell.identifier)
    }
    
    private var noAlarmBackgroundView = NoItemView(title: "알림이 없습니다", description: "")
    
    // MARK: - Properties
    
    private var dataSource: UITableViewDiffableDataSource<PushAlarmSection, PushAlarmItem>?
    private var sections = [PushAlarmSection]()
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDatasource()
        pushAlarmTableView.delegate = self
    }
    
    // MARK: - Bind
    
    func bind(reactor: PushAlarmReactor) {
        // MARK: Action
        
        
        
        // MARK: State
        
        reactor.state
            .map { $0.pushAlarmItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                if items.isEmpty {
                    print("items is Empty")
                    owner.noAlarmBackgroundView.isHidden = false
                    owner.pushAlarmTableView.isHidden = true
                } else {
                    print("items is not empty")
                    owner.noAlarmBackgroundView.isHidden = true
                    owner.pushAlarmTableView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - SetUp
    
    private func setUI() {
        view.backgroundColor = .white
        setBackBellNaviBar("H M O A")
        pushAlarmTableView.separatorStyle = .none
    }
    
    private func setAddView() {
        [   noAlarmBackgroundView,
            pushAlarmTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        pushAlarmTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noAlarmBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(164)
            make.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - Data Source Initialization
    
    private func configureDatasource() {
        dataSource = .init(tableView: pushAlarmTableView,
                           cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .list:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: PushAlarmCell.identifier,
                    for: indexPath) as! PushAlarmCell
                
                cell.configureCell()
                cell.selectionStyle = .none
                
                return cell
            }
        })
        
        // MARK: Initial Snapshot
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<PushAlarmSection, PushAlarmItem>()
        initialSnapshot.appendSections([.list])
        
        sections = initialSnapshot.sectionIdentifiers
        dataSource?.apply(initialSnapshot)
    }
}

extension PushAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
