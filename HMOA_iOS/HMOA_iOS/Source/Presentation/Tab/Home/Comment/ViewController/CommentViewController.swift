//
//  CommentViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/21.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class CommentViewController: UIViewController, View {
    
    // MARK: - Properties
    var perfumeId: Int = 0

    private var dataSource: RxCollectionViewSectionedReloadDataSource<CommentSection>!
    lazy var commendReactor = CommendListReactor(perfumeId)
    var disposeBag = DisposeBag()

    // MARK: - UI Component
    
    let topView = CommentTopView()
    let bottomView = CommentBottomView()
    
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.alwaysBounceVertical = true
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("댓글")
        configureUI()
        configureCollectionViewDataSource()
        bind(reactor: commendReactor)
    }
}

extension CommentViewController {

    func bind(reactor: CommendListReactor) {
        
        // action
        reactor.action.onNext(.viewDidLoad)

        collectionView.rx.itemSelected
            .map { Reactor.Action.didTapCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // state
        reactor.state
            .map { $0.comments }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.commentCount }
            .distinctUntilChanged()
            .map { String($0) }
            .bind(to: topView.commentCountLabel.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.presentCommentId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentDetailViewController)
            .disposed(by: disposeBag)
        
    }
    
    func configureCollectionViewDataSource() {
        
        dataSource = RxCollectionViewSectionedReloadDataSource<CommentSection>(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .commentCell(let reactor, _):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                cell.reactor = reactor
                
                return cell
            }
        })
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        [   topView,
            collectionView,
            bottomView
        ]   .forEach { view.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(72)
        }
    }
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 102)
    }
}
