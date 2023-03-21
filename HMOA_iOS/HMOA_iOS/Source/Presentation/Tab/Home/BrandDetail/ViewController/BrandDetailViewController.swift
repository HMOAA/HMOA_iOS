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
import RxDataSources

class BrandDetailViewController: UIViewController, View {
    typealias Reactor = BrandDetailReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - UI Component
    private var dataSource: RxCollectionViewSectionedReloadDataSource<BrandDetailModel>!

    let homeBarButton = UIButton().makeImageButton(UIImage(named: "homeNavi")!)
    let searchBarButton = UIButton().makeImageButton(UIImage(named: "search")!)
    let backBarButton = UIButton().makeImageButton(UIImage(named: "backButton")!)

    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        
        $0.register(BrandDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandDetailHeaderView.identifier)
        $0.register(BrandDetailCollectionViewCell.self, forCellWithReuseIdentifier: BrandDetailCollectionViewCell.identifier)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()

    }
}

extension BrandDetailViewController {
    
    // MARK: - Bind
    func bind(reactor: BrandDetailReactor) {
        
        configureCollectionViewDataSource()

        // MARK: - Action
        
        // 뒤로가기 버튼 클릭
        backBarButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // CollectionView 바인딩
        reactor.state
            .map { [$0.section] }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // NavigationBar title 설정
        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .bind(onNext: self.setNavigationBarTitle)
            .disposed(by: disposeBag)
        
        // pop VC
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in } 
            .bind(onNext: self.popViewController)
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
    
    func configureNavigationBar() {
        let backBarButtonItem = self.navigationItem.makeImageButtonItem(backBarButton)
        let homeBarButtonItem = self.navigationItem.makeImageButtonItem(homeBarButton)
        let searchBarButtonItem = self.navigationItem.makeImageButtonItem(searchBarButton)
        
        self.navigationItem.leftBarButtonItems = [backBarButtonItem, spacerItem(15), homeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<BrandDetailModel>(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            
            switch item {
            case .perfumeList(let perfume):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandDetailCollectionViewCell.identifier, for: indexPath) as? BrandDetailCollectionViewCell else { return UICollectionViewCell() }
                
                cell.reactor = BrandDetailCellReactor(perfume)
                return cell
            }
            
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

            var header = UICollectionReusableView()
            
            
            switch indexPath.section {
            case 0:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandDetailHeaderView.identifier, for: indexPath) as? BrandDetailHeaderView else { return UICollectionReusableView() }
                
                headerView.reactor = BrandDetailHeaderReactor(self.reactor!.currentState.brandId)
                header = headerView
                
            default: return header
                
            }
            
            return header
        })
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
        return CGSize(width: UIScreen.main.bounds.width, height: 242)
    }
}

