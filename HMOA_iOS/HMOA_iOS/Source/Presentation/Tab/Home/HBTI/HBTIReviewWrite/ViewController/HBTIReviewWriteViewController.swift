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
import PhotosUI

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
        $0.isScrollEnabled = false
        
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
    
    private var datasource: UICollectionViewDiffableDataSource<PhotoSection, PhotoSectionItem>?
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDatasource()
        setNotificationKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        textView.resignFirstResponder()
    }
           
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            // textView가 키보드 위에 남도록 contentInset을 조절
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 20, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReviewWriteReactor) {
        
        // MARK: Action
        addImageButton.rx.tap
            .map { Reactor.Action.didTapAddPhotoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // textView 사용자가 입력 시작
        textView.rx.didBeginEditing
            .map { Reactor.Action.didBeginEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //textView text 감지
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map { Reactor.Action.didChangeTextViewEditing($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 확인 버튼 클릭
        okButton.rx.tap
            .map { Reactor.Action.didTapOkButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.content }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, content in
                owner.textView.text = content
                owner.textView.textColor =
                content == "내용을 입력해주세요" ? .customColor(.gray3) : .white
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPresentToAlbum }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                let selectionLimit = 3 - reactor.currentState.photoCount
                if selectionLimit == 0 {
                    owner.showAlert(title: "HMOA",
                                    message: "사진은 3개까지 업로드 할 수 있습니다",
                                    buttonTitle1: "확인")
                } else {
                    var config = PHPickerConfiguration()
                    config.filter = .images
                    config.selectionLimit = selectionLimit
                    
                    let pickerVC = PHPickerViewController(configuration: config)
                    pickerVC.delegate = self
                    
                    owner.view.endEditing(true)
                    owner.present(pickerVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.images }
            .distinctUntilChanged()
            .delay(.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, item in
                guard let datasource = owner.datasource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<PhotoSection, PhotoSectionItem>()
                snapshot.appendSections([.photo])
                
                item.forEach { snapshot.appendItems([.photoCell($0, nil)], toSection: .photo) }
                DispatchQueue.main.async {
                    datasource.apply(snapshot, animatingDifferences: false)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.okButtonEnable }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isEnable in
                owner.okButton.isEnabled = isEnable
                owner.okButton.setTitleColor(isEnable ? .white : .customColor(.gray3), for: .normal)
            })
            .disposed(by: disposeBag)
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
    
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource<PhotoSection, PhotoSectionItem>(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, item in
            switch item {
            case .photoCell(let writePhoto, _):
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
                
                cell.isZoomEnabled = false
                cell.updateCell(writePhoto!.image)
                cell.configureXButton()
                cell.xButton.rx.tap
                    .map { Reactor.Action.didTapXButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        })
    }
}

extension HBTIReviewWriteViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var items: [WritePhoto] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { (item, error) in
                    DispatchQueue.main.async {
                        if let image = item as? UIImage {
                            items.append(WritePhoto(photoId: nil, image: image))
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.reactor?.action.onNext(.didSelectedImage(items))
            picker.dismiss(animated: true)
        }
    }
    
    private func setNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
