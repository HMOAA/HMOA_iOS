//
//  SearchViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

class SearchViewController: UIViewController, View {
    typealias Reactor = SearchReactor
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    
    private lazy var keywordVC = SearchKeywordViewController()
    private lazy var listVC = SearchListViewController()
    private lazy var ResultVC = SearchResultViewController()
    private lazy var containerView = UIView()
    
    lazy var backButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.leftView = UIView()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "제품/브랜드/키워드 검색"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
}

extension SearchViewController {
    
    
    // MARK: - Binding
    func bind(reactor: SearchReactor) {
        // MARK: - Action
        
        // 뒤로 가기 버튼 클릭
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Text 입력
        searchBar.rx.text.orEmpty
            .filter { $0 != "" }
            .map { _ in Reactor.Action.didChangeTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 검색 버튼 클릭
        searchBar.rx.searchButtonClicked
            .map { Reactor.Action.didEndTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // keywordVC - viewDidLoad
        keywordVC.rx.viewDidLoad
            .map { Reactor.Action.keywordViewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 이전 뷰 컨트롤러로 이동
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: self.popViewController)
            .disposed(by: disposeBag)
        
        // 텍스트 값이 변경되면 listVC으로 이동
        reactor.state
            .map { $0.isChangeTextField }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: { self.changeViewController(self.listVC) })
            .disposed(by: disposeBag)
        
        // 검색 버튼 눌러지면 ResultVC으로 이동
        reactor.state
            .map { $0.isEndTextField }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: { self.changeViewController(self.ResultVC) })
            .disposed(by: disposeBag)
        
        // keywordVC에서 viewDidLoad발생시 받아온 keywrods 데이터 바인딩
        reactor.state
            .map { $0.keywords }
            .distinctUntilChanged()
            .bind(onNext: {
                self.keywordVC.keywordList.addTags($0)
            })
            .disposed(by: disposeBag)
        
        // 연관 검색어 값이 바뀌면 tableView에 바인딩
        reactor.state
            .map { $0.lists }
            .distinctUntilChanged()
            .bind(to: self.listVC.tableView.rx.items(
                cellIdentifier: SearchListTableViewCell.identifier,
                cellType: SearchListTableViewCell.self)) { index, item, cell in
                    cell.updateCell(item)
            }
            .disposed(by: disposeBag)

        // 화면이 바뀌면 이전 페이지(VC)의 자식관계를 해지시켜줌
        reactor.state
            .map { $0.prePage }
            .distinctUntilChanged()
            .bind(onNext: {
                switch $0 {
                case 1:
                    self.removeChiledViewController(self.keywordVC)
                case 2:
                    self.removeChiledViewController(self.listVC)
                case 3:
                    self.removeChiledViewController(self.ResultVC)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        
        view.backgroundColor = .white
        
        [   keywordVC,
            listVC,
            ResultVC
        ]   .forEach {  self.addChild($0)   }
        
        [   containerView
        ]   .forEach { view.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.changeViewController(self.keywordVC)
    }
    
    
    func configureNavigationBar() {
     
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        let searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: self.navigationController!.view.frame.size.width - 42, height: 30)
        
        self.navigationItem.leftBarButtonItems = [backButtonItem]
        
        self.navigationItem.titleView = searchBarWrapper
    }
    
    // MARK: - functions
    
    // 입력받은 VC를 containerView에 호출
    func changeViewController(_ vc: UIViewController) {
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.didMove(toParent: self)
    }
    
    // 입력받은 VC의 자식관계 해제
    func removeChiledViewController(_ vc: UIViewController) {
        vc.willMove(toParent: self)
        vc.removeFromParent()
        vc.view.removeFromSuperview()
    }
}
