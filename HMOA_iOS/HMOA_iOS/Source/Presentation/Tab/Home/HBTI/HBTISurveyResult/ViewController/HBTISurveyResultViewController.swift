//
//  HBTISurveyResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 8/12/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTISurveyResultViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private let loadingView = HBTILoadingView()
    
    private let resultView = UIView()
    
    private let bestLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "OOO님에게 딱 맞는 향료는\n'시트러스'입니다", lineHeight: 27)
        $0.numberOfLines = 2
    }
    
    private let secondThirdLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard, size: 14, color: .gray3)
        $0.setTextWithLineHeight(text: "2위: 플로럴\n3위: 스파이스", lineHeight: 20)
        $0.numberOfLines = 2
    }
    
    private lazy var hbtiSurveyResultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            HBTISurveyResultCell.self,
            forCellWithReuseIdentifier: HBTISurveyResultCell.identifier
        )
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 15)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .black
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTISurveyResultSection, HBTISurveyResultItem>?
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyResultReactor) {
        
        // MARK: Action
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.isTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.resultInfo }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(onNext: updateLabels(with:))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.noteItemList }
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .recommend, withItems: items)
                owner.updateLoadingViewIsHidden(isHidden: !items.isEmpty)
            })
            .disposed(by: disposeBag)
        
        // TODO: 향료 선택 가이드 VC로 push하도록 변경
        reactor.state
            .map { $0.isPushNextVC }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(onNext: presentHBTINoteViewController)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Functions
    
    private func setUI() {
        view.backgroundColor = .white
        setBackToHBTIVCNaviBar("향BTI")
        hbtiSurveyResultCollectionView.isScrollEnabled = false
        resultView.isHidden = true
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            loadingView,
            resultView
        ] .forEach { view.addSubview($0) }
        
        [
            bestLabel,
            secondThirdLabel,
            hbtiSurveyResultCollectionView,
            nextButton
        ] .forEach { resultView.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        resultView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bestLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        secondThirdLabel.snp.makeConstraints { make in
            make.top.equalTo(bestLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(16)
        }
        
        hbtiSurveyResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(secondThirdLabel.snp.bottom).offset(29)
            make.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(400)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let bannerWidthRatio = 249.0 / 360.0
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(378)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(bannerWidthRatio),
                heightDimension: .absolute(378)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.interGroupSpacing = 16
            
            return section
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: hbtiSurveyResultCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .recommand(let note):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTISurveyResultCell.identifier,
                    for: indexPath) as! HBTISurveyResultCell
                
                cell.configureCell(note: note)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTISurveyResultSection, HBTISurveyResultItem>()
        initialSnapshot.appendSections([.recommend])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: HBTISurveyResultSection, withItems items: [HBTISurveyResultItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension HBTISurveyResultViewController {
    private func updateLoadingViewIsHidden(isHidden: Bool) {
        loadingView.isHidden = isHidden
        resultView.isHidden = !isHidden
    }
    
    private func updateLabels(with resultInfo: [String: String]) {
        guard let nickname = resultInfo["nickname"],
              let best = resultInfo["best"],
              let second = resultInfo["second"],
              let third = resultInfo["third"] else { return }
        
        loadingView.descriptionLabel.text = "\(nickname)님에게 딱 맞는 \n향료를 추천하는 중입니다."
        bestLabel.text = "\(nickname)님에게 딱 맞는 향료는\n'\(best)'입니다"
        secondThirdLabel.text = "2위: \(second)\n3위: \(third)"
    }
}
