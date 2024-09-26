//
//  OrderCancelLogViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderCancelLogViewController: UIViewController, View {

    // MARK: - UI Components
    private lazy var orderCancleLogTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(OrderCancelLogCell.self, forCellReuseIdentifier: OrderCancelLogCell.identifier)
    }

    // MARK: - Properties
    
    private var dataSource: UITableViewDiffableDataSource<OrderCancelLogSection, OrderCancelLogItem>?

    var disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setAddView()
        setConstraints()
        configureDatasource()
    }

    // MARK: - Bind

    func bind(reactor: OrderCancelLogReactor) {

        // MARK: Action

        // MARK: State
    }

    // MARK: - Functions

    private func setUI() {
        setClearBackNaviBar("환불 / 반품 내역", .black)
        view.backgroundColor = .white
        orderCancleLogTableView.separatorStyle = .none
    }

    // MARK: Add Views
    private func setAddView() {
        [
            orderCancleLogTableView
        ]   .forEach { view.addSubview($0) }
    }

    // MARK: Set Constraints
    private func setConstraints() {
        orderCancleLogTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Data Source Initialization
    
    private func configureDatasource() {
        dataSource = .init(tableView: orderCancleLogTableView,
                           cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OrderCancelLogCell.identifier,
                for: indexPath) as! OrderCancelLogCell
            
            cell.configureCell()
            cell.selectionStyle = .none
            
            return cell
        })
        
        // MARK: Initial Snapshot
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<OrderCancelLogSection, OrderCancelLogItem>()
        initialSnapshot.appendSections([.cancel])
        initialSnapshot.appendItems([.order("1"), .order("2")])
        
        dataSource?.apply(initialSnapshot)
    }

}
