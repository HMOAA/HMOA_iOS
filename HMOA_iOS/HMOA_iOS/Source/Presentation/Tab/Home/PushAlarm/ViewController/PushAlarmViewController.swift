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
    
    private var bellButton = UIButton().then {
        $0.setImage(UIImage(named: "bellOn"), for: .selected)
        $0.setImage(UIImage(named: "bellOff"), for: .normal)
    }
    
    private lazy var bellBarButtonItem = UIBarButtonItem(customView: bellButton)
    
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
    }
    
    // MARK: - Bind
    
    func bind(reactor: PushAlarmReactor) {
        
        // MARK: Action
        
        // viewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pushAlarmTableView.rx.itemSelected
            .map { Reactor.Action.didTapAlarmCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pushAlarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        LoginManager.shared.isPushAlarmAuthorization
            .map { Reactor.Action.settingAlarmAuthorization($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        LoginManager.shared.isUserSettingAlarm
            .map { Reactor.Action.settingIsUserSetting($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bellButton.rx.tap
            .map { Reactor.Action.didTapBellButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.pushAlarmItems }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updatePushALarmTableViewIsHidden(isHidden: items.isEmpty)
                owner.updateSnapshot(for: .list, with: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedAlarm }
            .compactMap { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self) { owner, alarm in
                let url = alarm.deeplink
                owner.handleDeeplink(url)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isTapBell }
            .filter { $0 }
            .bind(with: self) { owner, _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isOnBellButton }
            .distinctUntilChanged()
            .observe(on:MainScheduler.asyncInstance)
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isOn in
                LoginManager.shared.isUserSettingAlarm.onNext(isOn)
                self.bellButton.isSelected = isOn
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - SetUp
    
    private func setUI() {
        view.backgroundColor = .white
        setBackBellNaviBar("H M O A", bellButton: bellBarButtonItem)
        pushAlarmTableView.separatorStyle = .none
        noAlarmBackgroundView.isHidden = true
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
                
                cell.configureCell(item.pushAlarm!)
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
    
    private func updateSnapshot(for section: PushAlarmSection, with items: [PushAlarmItem]) {
        
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Function

extension PushAlarmViewController {
    private func updatePushALarmTableViewIsHidden(isHidden: Bool) {
        noAlarmBackgroundView.isHidden = !isHidden
        pushAlarmTableView.isHidden = isHidden
    }
    
    private func handleDeeplink(_ url: String) {
        let path = url.replacingOccurrences(of: "hmoa://", with: "").split(separator: "/")
        let category = String(path[0])
        let ID = Int(String(path[1]))!
        
        switch category {
        case "community":
            presentCommunityDetailVC(ID)
        case "perfume_comment":
            presentDetailViewController(ID)
            // TODO: 댓글 목록으로 이동
        default:
            print("unknown category: \(category)")
        }
    }
}

// MARK: - TableView Delegate

extension PushAlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
