//
//  SearchListViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/27.
//

import UIKit

class SearchListViewController: UIViewController {

    // MARK: - UI Component
    
    lazy var tableView = UITableView().then {
        $0.register(SearchListTableViewCell.self, forCellReuseIdentifier: SearchListTableViewCell.identifier)
        $0.separatorStyle = .none
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SearchListViewController {
    
    // MARK: - Configure
    
    func configureUI() {
        
        view.addSubview(tableView)
                
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

