//
//  TotalPerfumeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class TotalPerfumeViewController: UIViewController, View {
    typealias Reactor = TotalPerfumeReactor
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var dataSource: RxCollectionViewSectionedReloadDataSource<TotalPerfumeSection>!
    // MARK: - UI Component
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(BrandDetailCollectionViewCell.self, forCellWithReuseIdentifier: BrandDetailCollectionViewCell.identifier)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.setBackItemNaviBar("전체보기")
    }
}

extension TotalPerfumeViewController {
    
    // MARK: - bind
    
    func bind(reactor: TotalPerfumeReactor) {
        configureDataSource()
        
        // MARK: - Action
        
        
        // MARK: - State
        reactor.state
            .map { $0.section }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
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
    
    func configureDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<TotalPerfumeSection>(configureCell: { _, collectionView, indexPath, item in
            switch item {
            case .perfumeList(let perfume):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandDetailCollectionViewCell.identifier, for: indexPath) as? BrandDetailCollectionViewCell else { return UICollectionViewCell() }
                
                cell.reactor = BrandDetailCellReactor(perfume)
                
                return cell
            }
        })
    }
}

extension TotalPerfumeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 28) / 2
        let heigth = width + 82
        
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 10, bottom: 0, right: 10)
    }
}


