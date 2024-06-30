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
    
    // MARK: - Properties
    
    private var dataSource: UITableViewDiffableDataSource<PushAlarmSection, PushAlarmItem>?
    private var sections = [PushAlarmSection]()
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        configureDatasource()
        pushAlarmTableView.delegate = self
    }
    
    // MARK: - Bind
    
    func bind(reactor: PushAlarmReactor) {
        
    }
    
    // MARK: - SetUp
    
    private func setUI() {
        view.backgroundColor = .white
        setBackBellNaviBar("H M O A")
        view.addSubview(pushAlarmTableView)
        pushAlarmTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        pushAlarmTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        initialSnapshot.appendItems([.pushAlarm(PushAlarm(ID: 1, category: "Event", content: "테스트", pushDate: "오늘", deepLink: "", isRead: false)), .pushAlarm(PushAlarm(ID: 2, category: "Event", content: "테스트", pushDate: "오늘", deepLink: "", isRead: false))], toSection: .list)
        
        sections = initialSnapshot.sectionIdentifiers
        dataSource?.apply(initialSnapshot)
    }
}

extension PushAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
