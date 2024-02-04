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
import Hero

class BrandSearchViewController: UIViewController, View {
    typealias Reactor = BrandSearchReactor

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<BrandListSection, BrandCell>!
    
    var disposeBag = DisposeBag()
    

    // MARK: - UI Component
    private lazy var backButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    private lazy var searchBar = UISearchBar().then {
        $0.showsBookmarkButton = true
        $0.setImage(UIImage(named: "clearButton"), for: .clear, state: .normal)
        $0.setImage(UIImage(named: "search")?.withTintColor(.customColor(.gray3)), for: .bookmark, state: .normal)
        $0.searchTextField.leftView = UIView()
        $0.searchTextField.backgroundColor = .white
        $0.searchTextField.textAlignment = .left
        $0.searchTextField.font = .customFont(.pretendard_light, 16)
        $0.placeholder = "브랜드 검색"
    }
    
    private lazy var layout = UICollectionViewFlowLayout()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(BrandListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandListHeaderView.identifier)
        $0.register(BrandListCollectionViewCell.self, forCellWithReuseIdentifier: BrandListCollectionViewCell.identifier)
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchNavigationBar(backButton, searchBar: searchBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hero.isEnabled = false
    }
}

extension BrandSearchViewController {
    // MARK: - bind
    
    func bind(reactor: BrandSearchReactor) {
        configureCollectionViewDataSource()

        // MARK: - Action
        rx.viewDidLoad
            .map { Reactor.Action.scrollCollectionView(1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 클릭
        backButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 브랜드 Cell 클릭
        collectionView.rx.itemSelected
            .map {
                let item = self.dataSource.itemIdentifier(for: $0)
                switch item {
                case .BrandItem(let brand):
                    return brand
                case .none:
                    return nil
                }
            }
            .compactMap { $0 }
            .map { Reactor.Action.didTapItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 텍스트 입력
        searchBar.rx.text
            .orEmpty
            .map { Reactor.Action.updateSearchResult($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // MARK: - State
 
        // CollectionView 바인딩
        reactor.state
            .map { $0.sections }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                var snapshot = NSDiffableDataSourceSnapshot<BrandListSection, BrandCell>()
                snapshot.appendSections(sections)
                
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        // 이전 화면으로 이동
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 브랜드 상세 페이지로 이동
        reactor.state
            .map { $0.selectedItem }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: {
                self.presentBrandDetailViewController($0.brandId)
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        view.backgroundColor = .white
        
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<BrandListSection, BrandCell>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .BrandItem(let brand):
                
                guard let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandListCollectionViewCell.identifier, for: indexPath) as? BrandListCollectionViewCell else { return UICollectionViewCell() }
                
                brandCell.updateCell(brand)
                
                return brandCell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { (collectionview, kind, indexPath) -> UICollectionReusableView in
            
            guard let header = collectionview.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandListHeaderView.identifier, for: indexPath) as? BrandListHeaderView else { return UICollectionReusableView() }
            
            header.updateUI(self.reactor!.currentState.sections[indexPath.section].consonant)
            
            return header
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            var row = indexPath.section + 2
            if row >= 10 { row += 1 }
            reactor?.action.onNext(.scrollCollectionView(row))
        }
        
    }
}

