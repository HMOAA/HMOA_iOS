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
import RxDataSources

class BrandSearchViewController: UIViewController, View {
    typealias Reactor = BrandSearchReactor

    // MARK: - Properties
    private var dataSource: RxCollectionViewSectionedReloadDataSource<BrandSectionModel>!
    
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
        $0.register(BrandListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandListHeaderView.identifier)
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
        configureCollectionViewDataSource()

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
        
        // 브랜드 Cell 클릭
        collectionView.rx.modelSelected(BrandCell.self)
            .map { Reactor.Action.didTapItem($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
 
        reactor.state
            .map { [$0.firstSection, $0.secondSection, $0.thridSection, $0.fourthSection, $0.fiveSection] }
            .distinctUntilChanged()
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        // 이전 화면으로 이동
        reactor.state
            .map { $0.isPopVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: popViewController)
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
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<BrandSectionModel>(configureCell: { _, collectionView, indexPath, item in
            switch item {
            case .BrandItem(let brand):
                
                guard let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandListCollectionViewCell.identifier, for: indexPath) as? BrandListCollectionViewCell else { return UICollectionViewCell() }
                
                brandCell.updateCell(brand)
                
                return brandCell
            }
            
        }, configureSupplementaryView: { (_, collectionview, kind, indexPath) -> UICollectionReusableView in
          
            guard let header = collectionview.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrandListHeaderView.identifier, for: indexPath) as? BrandListHeaderView else { return UICollectionReusableView() }
            
            switch indexPath.section {
            case 0:
                header.updateUI("ㄱ")
            case 1:
                header.updateUI("ㄴ")
            case 2:
                header.updateUI("ㄷ")
            case 3:
                header.updateUI("ㄹ")
            case 4:
                header.updateUI("ㅁ")
            default:
                break
            }
            
            return header
        })
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
}
