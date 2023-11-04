//
//  DetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<DetailSection, DetailSectionItem>!

    let detailView = DetailView()
    
    let bottomView = DetailBottomView()
    
    let homeBarButton = UIButton().makeImageButton(UIImage(named: "homeNavi")!)
    let searchBarButton = UIButton().makeImageButton(UIImage(named: "search")!)
    let backBarButton = UIButton().makeImageButton(UIImage(named: "backButton")!)
    
    lazy var optionView = OptionView().then {
        $0.parentVC = self
        $0.reactor = OptionReactor()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViewDataSource()
        configreNavigationBar()
    }
}

// MARK: - Functions
extension DetailViewController {
    
    // MARK: - Bind
    
    func bind(reactor: DetailViewReactor) {
        
        // MARK: - Action
        LoginManager.shared.isLogin
            .map { Reactor.Action.viewDidLoad($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        detailView.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        // viewWillAppear
        rx.viewWillAppear
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 작성 버튼 클릭
        bottomView.wirteButton.rx.tap
            .map { Reactor.Action.didTapWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 클릭
        backBarButton.rx.tap
            .map { Reactor.Action.didTapBackButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 홈 버튼 클릭
        homeBarButton.rx.tap
            .map { Reactor.Action.didTapHomeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 검색 버튼 클릭
        searchBarButton.rx.tap
            .map { Reactor.Action.didTapSearchButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //좋아요 버튼 클릭
        bottomView.likeButton.rx.tap
            .map { Reactor.Action.didTapLikeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 셀 터치
        detailView.collectionView.rx.itemSelected
            .filter { $0.section == 2 }
            .map { Reactor.Action.didTapCommentCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 같은 브랜드 향수 셀 터치
        detailView.collectionView.rx.itemSelected
            .filter { $0.section == 3 }
            .map { Reactor.Action.didTapSimillarCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 옵션 뷰 삭제 버튼 터치 시
        optionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didDeleteComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // collectionView 바인딩
        reactor.state
            .map { $0.sections }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, sections in
                var snapshot = NSDiffableDataSourceSnapshot<DetailSection, DetailSectionItem>()
                snapshot.appendSections(sections)
                
                sections.forEach { section in
                    snapshot.appendItems(section.items, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            }).disposed(by: disposeBag)
        
        // 댓글 전체 보기 페이지로 이동
        reactor.state
            .map { $0.persentCommentPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentViewContorller)
            .disposed(by: disposeBag)
        
        // 댓글 디테일 페이지로 이동
        reactor.state
            .map { $0.presentComment }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentCommentDetailViewController)
            .disposed(by: disposeBag)
        
        // TODO: - simillar cell 향수 아이디 받아오기
        // 향수 디테일 페이지로 이동
        reactor.state
            .map { $0.presentPerfumeId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentDatailViewController)
            .disposed(by: disposeBag)
        
        // 댓글 작성 페이지로 이동
        reactor.state
            .map { $0.isPresentCommentWirteVC }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.presentCommentWriteViewController(.perfumeDetail(reactor))
            })
            .disposed(by: disposeBag)
        
        // 홈 페이지로 이동
        reactor.state
            .map { $0.isPopRootVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        // 뒤로 이동
        reactor.state
            .map { $0.isPopVC}
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: self.popViewController)
            .disposed(by: disposeBag)
        
        // 검색 페이지로 이동
        reactor.state
            .map { $0.isPresentSearchVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: presentSearchViewController)
            .disposed(by: disposeBag)
        
        // 향수 좋아요 여부 바인딩
        reactor.state
            .map { $0.isLiked }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: bottomView.likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        // 로그인 안 되어 있을 시
        reactor.state
            .map { $0.isTapWhenNotLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.presentAlertVC(title: "로그인 후 이용가능한 서비스입니다",
                                     content: "입력하신 내용을 다시 확인해주세요",
                                     buttonTitle: "로그인 하러가기 ")
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindHeader(_ header: CommentHeaderView) {
        reactor?.state
            .map { "+\($0.commentCount)" }
            .bind(to: header.countLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func bindPerfumeInfoCell(_ cell: PerfumeInfoCell) {
        
        // Action
        
        // BrandView 터치 이벤트
        cell.perfumeInfoView
            .brandView.tapGesture.rx.event
            .map { _ in Reactor.Action.didTapBrandView }
            .bind(to: self.reactor!.action)
            .disposed(by: cell.disposeBag)
        
        // BrandDetailVC로 present
        reactor?.state
            .map { $0.presentBrandId }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: presentBrandDetailViewController)
            .disposed(by: cell.disposeBag)
        
        //좋아요 이미지 변경
        reactor?.state
            .map { $0.isLiked }
            .skip(1)
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { isLiked in
                cell.perfumeInfoView.perfumeLikeImageView.image = !isLiked ? UIImage(named: "heart") : UIImage(named: "heart_fill")
            })
            .disposed(by: disposeBag)
        
        //좋아요 개수 바인딩
        reactor?.state
            .compactMap { $0.likeCount }
            .skip(1)
            .map { "\($0)" }
            .bind(to: cell.perfumeInfoView.perfumeLikeCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        
        [   detailView,
            bottomView,
            optionView
        ]   .forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
        
        optionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configreNavigationBar() {
        setNavigationBarTitle("조말론 런던")
        
        let backBarButtonItem = self.navigationItem.makeImageButtonItem(backBarButton)
        let homeBarButtonItem = self.navigationItem.makeImageButtonItem(homeBarButton)
        let searchBarButtonItem = self.navigationItem.makeImageButtonItem(searchBarButton)
        
        self.navigationItem.leftBarButtonItems = [backBarButtonItem, spacerItem(15), homeBarButtonItem]
        self.navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
}

extension DetailViewController: UICollectionViewDelegate {
    
    func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailSection, DetailSectionItem>(collectionView: detailView.collectionView, cellProvider: {  collectionView, indexPath, item in
            
            switch item {
            case .topCell(let detail, _):
                guard let perfumeInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PerfumeInfoCell.identifier, for: indexPath) as? PerfumeInfoCell else { return UICollectionViewCell() }
                
                self.bindPerfumeInfoCell(perfumeInfoCell)
                perfumeInfoCell.updateCell(detail)
                return perfumeInfoCell
                
            case .evaluationCell(let evaluation, _):
                guard let evaluationCell = collectionView.dequeueReusableCell(withReuseIdentifier: EvaluationCell.identifier, for: indexPath) as? EvaluationCell else { return UICollectionViewCell() }
                
                evaluationCell.reactor = EvaluationReactor(
                    evaluation,
                    self.reactor!.currentState.perfumeId,
                    isLogin: self.reactor!.currentState.isLogin)
                
                
            
                return evaluationCell
                
            case .commentCell(let comment, _):
                guard let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                commentCell.updateCell(comment)
                
                commentCell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(comment?.id, comment?.content, nil, "Comment", nil, comment?.writed) }
                    .bind(to: self.optionView.reactor!.action)
                    .disposed(by: self.optionView.disposeBag)
                
                commentCell.optionButton.rx.tap
                    .map { DetailViewReactor.Action.didTapOptionButton(indexPath.row) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                    
                
                return commentCell
                
            case .similarCell(let similar, _):
                guard let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCell.identifier, for: indexPath) as? SimilarCell else { return UICollectionViewCell() }
                
                similarCell.updateUI(similar)
                return similarCell
                
            }
        })
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView in
            var header = UICollectionReusableView()
            
            switch indexPath.section {
            case 1:
                guard let evaluationHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EvaluationHeaderView.identifier, for: indexPath) as? EvaluationHeaderView else { return UICollectionReusableView() }
                
                header = evaluationHeader
                
            case 2:
                guard let commentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as? CommentHeaderView else { return UICollectionReusableView() }
                self.bindHeader(commentHeader)
                header = commentHeader
            default:
                guard let similarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimilarHeaderView.identifier, for: indexPath) as? SimilarHeaderView else { return UICollectionReusableView() }
                
                header = similarHeader
            }
            
            if kind == UICollectionView.elementKindSectionFooter {
                guard let commentFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier, for: indexPath) as? CommentFooterView else { return UICollectionReusableView() }
            
                
                commentFooter.moreButton.rx.tap
                    .map { Reactor.Action.didTapMoreButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: commentFooter.disposeBag)
                
                return commentFooter
            } else {
                return header
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && !reactor!.currentState.isPaging {
            reactor?.action.onNext(.willDisplaySecondSection)
        }
    }
}
