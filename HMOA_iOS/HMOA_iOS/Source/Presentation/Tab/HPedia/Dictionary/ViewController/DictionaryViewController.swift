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
    
    //MARK: - UI Components
    lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.register(DictionaryCell.self, forCellReuseIdentifier: DictionaryCell.identifier)
    }
    
    let searchBar = UISearchBar().configureHpediaSearchBar()
    
    //MARK: - Properties
    typealias Reactor = DictionaryReactor
    var disposeBag = DisposeBag()
    
    //MARK: - Init
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
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.top.equalTo(searchBar.snp.bottom).offset(13)
        }
    }

    func bind(reactor: DictionaryReactor) {
        
        // Action
        
        // ViewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // willDisplayCell
        tableView.rx.willDisplayCell
            .map { cell, index -> Int? in
                let currentItem = index.item
                if (currentItem + 1) % 15 == 0 && currentItem != 0 {
                    return currentItem / 15 + 1
                }
                return nil
            }
            .compactMap { $0 }
            .map { Reactor.Action.willDisplayCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        //tableView cell 터치
        tableView.rx.itemSelected
            .map { Reactor.Action.didTapItem($0) }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 텍스트 입력
        searchBar.rx.text
            .orEmpty
            .map { Reactor.Action.didSearchItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // State
        
        //collectionView binding
        reactor.state
            .map { $0.items }
            .bind(to: tableView.rx.items(cellIdentifier: DictionaryCell.identifier, cellType: DictionaryCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.updateCell(item)
            }.disposed(by: disposeBag)
        
        //navigationBar title 설정
        reactor.state
            .map { $0.title }
            .bind(onNext: setBackItemNaviBar)
            .disposed(by: disposeBag)
        
        //선택된 타이틀 DetailDictionaryVC로 push
        reactor.state
            .map { $0.selectedId }
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, id in
                owner.presentDetailDictionaryVC(reactor.currentState.type, id)
            })
            .disposed(by: disposeBag)
    }
}

extension DictionaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
