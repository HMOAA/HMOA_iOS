//
//  DictionaryViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class DictionaryViewController: UIViewController, View {
    
    typealias Reactor = DictionaryReactor
    var disposeBag = DisposeBag()
    
    lazy var tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(DictionaryCell.self, forCellReuseIdentifier: DictionaryCell.identifier)
    }
    
    let searchBar = UISearchBar().then {
        $0.layer.addBorder([.bottom], color: .customColor(.gray3), width: 1)
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(), for: .search, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.addLeftPadding(16)
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "키워드를 검색하세요"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    private func setAddView() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func setConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(13)
        }
    }

    func bind(reactor: DictionaryReactor) {
        
        // Action

        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        
        // State
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items(cellIdentifier: DictionaryCell.identifier, cellType: DictionaryCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.updateCell(item)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.title }
            .bind(with: self, onNext: { owner, title in
                owner.setNavigationBarTitle(title: title, color: .black, isHidden: false, isScroll: false)
            })
            .disposed(by: disposeBag)
        
        
    }
}

extension DictionaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
