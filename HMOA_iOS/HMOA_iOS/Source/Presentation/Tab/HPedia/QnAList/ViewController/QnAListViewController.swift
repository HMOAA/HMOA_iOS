//
//  QnAListViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/08.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class QnAListViewController: UIViewController, View {

    let searchBar = UISearchBar().configureHpediaSearchBar()
    
    let layout = UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 0
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(QnAListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAListHeaderView.identifier)
        $0.register(HPediaQnACell.self, forCellWithReuseIdentifier: HPediaQnACell.identifier)
    }
    
    let floatingButton = UIButton().then {
        $0.setImage(UIImage(named: "selectedAddButton"), for: .selected)
        $0.setImage(UIImage(named: "addButton"), for: .normal)
    }
    
    let recommendButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("추천")
        titleAttr.font = .customFont(.pretendard, 16)
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "floatingCircle")
        config.imagePlacement = .leading
        config.imagePadding = 7
        config.titleAlignment = .leading
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let giftButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("선물")
        titleAttr.font = .customFont(.pretendard, 16)
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "floatingCircle")
        config.imagePlacement = .leading
        config.imagePadding = 7
        config.titleAlignment = .leading
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    let etcButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("기타")
        titleAttr.font = .customFont(.pretendard, 16)
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "floatingCircle")
        config.imagePlacement = .leading
        config.imagePadding = 7
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    lazy var floatingButtons = [recommendButton, giftButton, etcButton]
    
    let floatingStackView = UIStackView().then {
        $0.backgroundColor = .black
        $0.isHidden = true
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 10
        $0.axis = .vertical
    }
    
    lazy var floatingView = UIView().then {
        $0.frame = view.frame
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        $0.alpha = 0
        $0.isHidden = true
        
    }
    
    var disposeBag = DisposeBag()
    let reactor = QNAListReactor()
    var datasource: UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        setNavigationBarTitle(title: "QnA", color: .white, isHidden: false, isScroll: false)
        configureDatasource()
        bind(reactor: reactor)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    private func setAddView() {
        
        floatingButtons.forEach {
            floatingStackView.addArrangedSubview($0)
        }
        
        [
            searchBar,
            collectionView,
            floatingView,
            floatingButton,
            floatingStackView
        ]   .forEach { view.addSubview($0) }

    }

    private func setConstraints() {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-13)
            make.width.height.equalTo(56)
        }
        
        floatingStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.width.equalTo(135)
            make.height.equalTo(137)
            make.bottom.equalTo(floatingButton.snp.top).offset(-8)
        }
        
        floatingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: QNAListReactor) {
        
        floatingButton.rx.tap
            .map { Reactor.Action.didTapFloatingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.items }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                var snapshot = NSDiffableDataSourceSnapshot<HPediaSection, HPediaSectionItem>()
                
                snapshot.appendSections([.qna])
                items.forEach {
                    snapshot.appendItems([.qna($0)], toSection: .qna)
                }
                
                DispatchQueue.main.async {
                    owner.datasource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFloatingButtonTap }
            .skip(1)
            .bind(with: self, onNext: { owner, isTap in
                owner.floatingButton.isSelected = isTap
                
                if !isTap {
                    UIView.animate(withDuration: 0.3) {
                        owner.floatingStackView.isHidden = true
                        owner.view.layoutIfNeeded()
                    }
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        owner.floatingView.alpha = 0
                    }) { _ in
                        owner.floatingView.isHidden = true
                    }
                } else {
                    owner.floatingView.isHidden = false
                    
                    UIView.animate(withDuration: 0.5) {
                        owner.floatingView.alpha = 1
                    }
                    
                    owner.floatingStackView.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        owner.floatingStackView.alpha = 1
                        owner.floatingStackView.isHidden = false
                        owner.view.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindHeader() {
        
    }
}

extension QnAListViewController: UICollectionViewDelegateFlowLayout {
    
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<HPediaSection, HPediaSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .qna(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HPediaQnACell.identifier, for: indexPath) as? HPediaQnACell else { return UICollectionViewCell() }
                cell.isListCell = true
                cell.configure(data)
                
                return cell
                
            default: return UICollectionViewCell()
            }
        })
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.item {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: QnAListHeaderView.identifier, for: indexPath) as? QnAListHeaderView else { return UICollectionReusableView() }
                
                return header
            default: return UICollectionReusableView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
    
}
