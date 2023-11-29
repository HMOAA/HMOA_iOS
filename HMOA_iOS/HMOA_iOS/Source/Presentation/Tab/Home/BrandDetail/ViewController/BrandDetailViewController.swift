//
//  BrandDetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/18.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

class BrandDetailViewController: UIViewController, View {
    typealias Reactor = BrandDetailReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    private var dataSource: UICollectionViewDiffableDataSource<BrandDetailSection, BrandDetailSectionItem>!
    
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        
        $0.register(BrandDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandDetailHeaderView.identifier)
        $0.register(BrandDetailCollectionViewCell.self, forCellWithReuseIdentifier: BrandDetailCollectionViewCell.identifier)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
}

extension BrandDetailViewController {
    
    // MARK: - Bind
    func bind(reactor: BrandDetailReactor) {
        
        configureCollectionViewDataSource()
        
        // MARK: - Action
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 향수 터치
        collectionView.rx.itemSelected
            .map { Reactor.Action.didTapPerfume($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        
        
        // MARK: - State
        
        // CollectionView 바인딩
        reactor.state
            .map { $0.section }
            .asDriver(onErrorRecover: { _ in return .empty()} )
            .drive(with: self, onNext: { owner, sections in
                var snapshot = NSDiffableDataSourceSnapshot<BrandDetailSection, BrandDetailSectionItem>()
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }).disposed(by: disposeBag)
        
        // NavigationBar title 설정
        reactor.state
            .map { $0.brand?.brandName ?? "" }
            .distinctUntilChanged()
            .bind(onNext: setBackHomeRightNaviBar)
            .disposed(by: disposeBag)
        
        // 향수 디테일 페이지로 이동
        reactor.state
            .compactMap { $0.presentPerfumeId }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
        
    }
    
    func bindHeader(_ headerView: BrandDetailHeaderView, reactor: BrandDetailReactor) {
        // Action
        
        // 좋아요순 버튼 터치
        headerView.sortButton.rx.tap
            .map { Reactor.Action.didTapLikeSortButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        // 브랜드 이름 바인딩
        reactor.state
            .compactMap { $0.brand }
            .map { $0.brandName }
            .bind(to: headerView.koreanLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 브랜드 이미지 바인딩
        reactor.state
            .compactMap { $0.brand }
            .map { URL(string: $0.brandImageUrl) }
            .bind(onNext: { url in
                headerView.brandImageView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        // 브랜드 영어 이름 바인딩
        reactor.state
            .compactMap { $0.brand }
            .map { $0.englishName }
            .bind(to: headerView.englishLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 향수 좋아요순 색 변경
        reactor.state
            .map { $0.isTapLiked }
            .bind(to: headerView.sortButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<BrandDetailSection, BrandDetailSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .perfumeList(let perfume):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandDetailCollectionViewCell.identifier, for: indexPath) as? BrandDetailCollectionViewCell else { return UICollectionViewCell() }
                
                cell.bindUI(perfume)
                return cell
            }
            
        })
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView in
            
            var header = UICollectionReusableView()
            
            
            switch indexPath.section {
            case 0:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandDetailHeaderView.identifier, for: indexPath) as? BrandDetailHeaderView else { return UICollectionReusableView() }
                
                self.bindHeader(headerView, reactor: self.reactor!)
                header = headerView
                return header
                
            default: return header
                
            }
        }
    }
}


extension BrandDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 28) / 2
        let heigth = width + 82
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 256)
    }
}

