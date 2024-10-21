//
//  HBTIReviewWriteViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/21/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIReviewWriteViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    // Navigation bar items
    private let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
    }
    
    private let titleNaviLabel = UILabel().then {
        $0.setLabelUI("향BTI 후기", font: .pretendard_medium, size: 20, color: .white)
        $0.font = .customFont(.pretendard_medium, 20)
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.white, for: .normal)
    }
    
    // writing area items
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    private let textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.isScrollEnabled = false
        
        // line Height 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.6
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customFont(.pretendard, 14),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white
        ]
        $0.typingAttributes = attributes
        
        $0.attributedText = NSAttributedString(string: "", attributes: attributes)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        $0.backgroundColor = .clear
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    private lazy var pageControl = UIPageControl().then {
        $0.isEnabled = false
        $0.pageIndicatorTintColor = .customColor(.gray2)
        $0.currentPageIndicatorTintColor = .customColor(.gray4)
        $0.isHidden = true
    }
    
    private let addImageButton = UIBarButtonItem(
        image: UIImage(named: "addImageButton"),
        style: .plain,
        target: nil,
        action: nil)
    
    private lazy var addImageView = UIToolbar().then {
        $0.tintColor = .black
        $0.backgroundColor = #colorLiteral(red: 0.8534707427, green: 0.8671818376, blue: 0.8862800002, alpha: 1)
        $0.sizeToFit()
        $0.items = [addImageButton]
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReviewWriteReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleNaviLabel)
        navigationController?.navigationBar.backgroundColor = .customColor(.gray4)
        navigationController?.navigationBar.standardAppearance.backgroundColor = .customColor(.gray4)
        view.backgroundColor = .customColor(.gray4)
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            backgroundView
        ].forEach { view.addSubview($0) }
        
        [
            scrollView,
            addImageView
        ].forEach { backgroundView.addSubview($0) }
        
        [
            contentView
        ].forEach { scrollView.addSubview($0) }
        
        [
            textView,
            collectionView,
            pageControl
        ].forEach { contentView.addArrangedSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(24)
            make.horizontalEdges.equalTo(view.snp.horizontalEdges).inset(32)
        }
        
        textView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(150)
        }

        collectionView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        addImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(34)
        }
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

