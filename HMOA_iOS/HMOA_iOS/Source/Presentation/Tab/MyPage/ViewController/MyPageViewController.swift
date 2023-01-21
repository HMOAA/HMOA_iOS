//
//  MyPageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - ViewModel
    let viewModel = MyPageViewModel()
    
    // MARK: - Properties
    let myPageView = MyPageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigationBarTitle(title: "마이페이지", isHidden: true)
    }
}

// MARK: - Functions

extension MyPageViewController {
    func configureUI() {
        
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
        
        [myPageView] .forEach { view.addSubview($0) }
        
        myPageView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCell(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.identifier, for: indexPath) as? MyPageCell else { return UITableViewCell() }
        
        cell.updateCell(viewModel.titleOfCell(indexPath))
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numOfSection
    }
}
