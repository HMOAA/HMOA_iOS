//
//  BrandSearchViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/16.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class BrandSearchViewController: UIViewController, View {
    typealias Reactor = BrandSearchReactor
    
    var disposeBag = DisposeBag()
    

    // MARK: - UI Component
    lazy var backButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.leftView = UIView()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "브랜드 검색"
    }
    
    lazy var layout = UICollectionViewFlowLayout()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(BrandListCollectionViewCell.self, forCellWithReuseIdentifier: BrandListCollectionViewCell.identifier)
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
}

extension BrandSearchViewController {
    // MARK: - bind
    
    func bind(reactor: BrandSearchReactor) {
        
        // MARK: - Action
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // 뒤로가기 버튼 클릭
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        // MARK: - State
        
        // 이전 화면으로 이동
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.brandList }
            .distinctUntilChanged()
            .bind(to: collectionView.rx.items(cellIdentifier: BrandListCollectionViewCell.identifier, cellType: BrandListCollectionViewCell.self)) { index, item, cell in
                cell.updateCell(item)
            }
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Configure
    
    func configureUI() {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
     
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        let searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: self.navigationController!.view.frame.size.width - 42, height: 30)
        
        self.navigationItem.leftBarButtonItems = [backButtonItem]
        
        self.navigationItem.titleView = searchBarWrapper
    }
}

extension BrandSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 56) / 4
        let heigth = width + 36
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
