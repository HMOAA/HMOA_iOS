//
//  QnADetailViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/11.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit
import RxGesture

class QnADetailViewController: UIViewController, View {

    //MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>!
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.isScrollEnabled = false
        $0.register(QnAPostHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier)
        $0.register(QnACommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(QnAPostCell.self, forCellWithReuseIdentifier: QnAPostCell.identifier)
        
    }
    
    lazy var noCommentLabel = UILabel().then {
        $0.isHidden = true
        $0.setLabelUI("아직 작성한 댓글이 없습니다", font: .pretendard_medium, size: 20, color: .black)
    }
    
    let commentWriteView = UIView().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = #colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)
    }
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = false
    }
    
    let colonLabel = UILabel().then {
        $0.setLabelUI(":", font: .pretendard, size: 14, color: .black)
    }
    
    let commentTextView = UITextView().then {
        $0.text = "댓글을 입력하세요"
        $0.isScrollEnabled = false
        $0.font = .customFont(.pretendard, 14)
        $0.backgroundColor = #colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)
    }
    
    let commentWriteButton = UIButton().then {
        $0.setImage(UIImage(named: "commentWrite"), for: .normal)
    }
    
    lazy var commentOptionView = OptionView().then {
        $0.parentVC = self
        $0.reactor = OptionReactor(["수정", "삭제", "댓글 복사"])
    }
    
    lazy var postOptionView = OptionView().then {
        $0.reactor = OptionReactor(["수정", "삭제", "글 복사"])
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setConstraints()
        setNavigationBarTitle(title: "Community", color: .white, isHidden: false)
        configureDataSource()
    }
    
    

    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        
        [
            profileImageView,
            colonLabel,
            commentTextView,
            commentWriteButton,
        ]   .forEach { commentWriteView.addSubview($0) }
        
        [
            collectionView,
            noCommentLabel,
            commentWriteView,
            commentOptionView,
            postOptionView
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noCommentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(462)
        }
        
        commentWriteView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(11)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        colonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(colonLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(36)
            make.top.bottom.equalToSuperview()
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(9)
            make.centerY.equalToSuperview()
        }
        
        commentOptionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postOptionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: QnADetailReactor) {
        
        // Action
        
        // 빈 화면 터치 시 키보드 내리기
        collectionView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        // viewDidLoad
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // textView 사용자가 입력 시작
        commentTextView.rx.didBeginEditing
            .map { Reactor.Action.didBeginEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //textView text 감지
        commentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map { Reactor.Action.didChangeTextViewEditing($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 댓글 작성 버튼 터치
        commentWriteButton.rx.tap
            .map { Reactor.Action.didTapCommentWriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 옵션 뷰 삭제 버튼 터치
        commentOptionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didDeletedComment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        //colectionView binding
        reactor.state
            .map { $0.sections }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, sections in
                
                var snapshot = NSDiffableDataSourceSnapshot<QnADetailSection, QnADetailSectionItem>()
                snapshot.appendSections(sections)
                sections.forEach { section in
                    snapshot.appendItems(section.item, toSection: section)
                }
                
                DispatchQueue.main.async {
                    owner.dataSource.apply(snapshot)
                }
            })
            .disposed(by: disposeBag)
        
        // 텍스트 뷰 터치 시 빈칸으로 만들기
        reactor.state
            .map { $0.isBeginEditing }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.commentTextView.text = ""
            }.disposed(by: disposeBag)
        
        // 텍스트 뷰 높이에 따라 commentWrite뷰 높이 변경
        reactor.state
            .map { $0.content }
            .map { _ in
                let contentSize = self.commentTextView.sizeThatFits(CGSize(width: self.commentTextView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
                return contentSize.height
            }
            .bind(with: self) { owner, height in
                owner.commentWriteView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 입력 시 키보드 내리기
        reactor.state
            .map { $0.isEndEditing }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.commentTextView.text = ""
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension QnADetailViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<QnADetailSection, QnADetailSectionItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .qnaPostCell(let qnaPost):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QnAPostCell.identifier, for: indexPath) as? QnAPostCell else { return UICollectionViewCell() }
                
                cell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(qnaPost.id, qnaPost.content, "Post") }
                    .bind(to: self.postOptionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                cell.updateCell(qnaPost)
                return cell
                
            case .commentCell(let comment):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                // optionView에 comment 정보 전달
                cell.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(comment?.id, comment?.content, "Comment") }
                    .bind(to: self.commentOptionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                // QnADetailReactor에 indexPathRow 전달
                cell.optionButton.rx.tap
                    .map { QnADetailReactor.Action.didTapOptionButton(indexPath.row) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                cell.updateCommunityComment(comment)
                return cell
            }
            
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnAPostHeaderView.identifier, for: indexPath) as? QnAPostHeaderView else { return UICollectionReusableView() }
                
                self.reactor?.state
                    .map { $0.sections[0].item[0].category }
                    .bind(to: header.recommendLabel.rx.text)
                    .disposed(by: self.disposeBag)
                
                return header
            default:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: QnACommentHeaderView.identifier, for: indexPath) as? QnACommentHeaderView else { return UICollectionReusableView() }
                
                self.reactor?.state
                    .map { $0.commentCount }
                    .bind(with: self, onNext: { owner, count in
                        if let count = count {
                            owner.noCommentLabel.isHidden = true
                            owner.collectionView.isScrollEnabled = true
                            header.commentCountLabel.text = "+\(count)"
                        } else {
                            owner.noCommentLabel.isHidden = false
                        }
                    })
                    .disposed(by: self.disposeBag)
                
                return header
            }
        }
    }
    
    func configureQnAPostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(268))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(14)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 46, leading: 16, bottom: 52, trailing: 16)
        sectionHeader.contentInsets = .init(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func configureQnACommentSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(102))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        sectionHeader.contentInsets = .init(top: 0, leading: 0, bottom: 12, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch section {
            case 0:
                return self.configureQnAPostSection()
            default:
                return self.configureQnACommentSection()
            }
            
        }
    }
}
