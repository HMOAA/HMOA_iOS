//
//  CommunityWriteViewController.swift
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
import PhotosUI

class CommunityWriteViewController: UIViewController, View {
    
    //MARK: - UI Components
    
    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
    }
    
    private let titleNaviLabel = UILabel().then {
        $0.font = .customFont(.pretendard_medium, 20)
        $0.textColor = .black
    }
    
    private let cancleButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
    }
    
    private let okButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
    }
    
    private let titleView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = .customFont(.pretendard_light, 16)
        $0.text = "제목:"
        $0.textColor = .black
    }
    
    private let titleTextField = UITextField().then {
        $0.font = .customFont(.pretendard, 14)
        $0.placeholder = "제목을 입력해주세요"
        $0.setPlaceholder(color: .customColor(.gray3))
    }
    
    private let titleCountLabel = UILabel().then {
        $0.text = "0/20"
        $0.font = .customFont(.pretendard_light, 14)
    }
    
    private let textView = UITextView().then {
        $0.font = .customFont(.pretendard, 14)
        $0.autocorrectionType = .no
        $0.isScrollEnabled = false
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
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout()).then {
        
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
    }
    
    private lazy var pageControl = UIPageControl().then {
        $0.isEnabled = false
        $0.pageIndicatorTintColor = .customColor(.gray2)
        $0.currentPageIndicatorTintColor = .customColor(.gray4)
        $0.isHidden = true
    }
    
    private let stackView = UIStackView().then {
        $0.spacing = 8
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    // MARK: - Properties
    
    private var datasource: UICollectionViewDiffableDataSource<PhotoSection, PhotoSectionItem>?
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatasource()
        setOkCancleNavigationBar(okButton: okButton, cancleButton: cancleButton, titleLabel: titleNaviLabel)
        setUpUI()
        setAddView()
        setConstraints()
        setNotificationKeyboard()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        titleTextField.resignFirstResponder()
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
    
    
    override func viewDidLayoutSubviews() {
        titleView.layer.addBorder([.top, .bottom], color: .black, width: 1)
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [
            titleLabel,
            titleTextField,
            titleCountLabel
        ]   .forEach { titleView.addSubview($0) }
        [
            textView,
            collectionView,
            pageControl
        ]   .forEach { stackView.addArrangedSubview($0) }
        
        [
            stackView
        ].forEach { scrollView.addSubview($0) }
        
        
        [
            titleView,
            scrollView,
            addImageView
        ]   .forEach { view.addSubview($0) }
        
    }
    
    private func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.centerY.equalToSuperview()
            make.width.equalTo(32)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(titleCountLabel.snp.leading).offset(-3)
        }
        
        titleCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.greaterThanOrEqualToSuperview().inset(15)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }

        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45)
        }
        
        textView.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width - 32)
            make.height.greaterThanOrEqualTo(150)
        }

        collectionView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        addImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(34)
        }
        
        
    }
    
    private func setNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Bind
    func bind(reactor: CommunityWriteReactor) {
        
        // MARK: - Action
        
        // ViewDidLoad
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 확인 버튼 클릭
        okButton.rx.tap
            .map { Reactor.Action.didTapOkButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 제목 변경
        titleTextField.rx.text.orEmpty
            .skip(1)
            .map { Reactor.Action.didChangeTitle($0) }
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
        
        // 이미지 버튼 터치
        addImageButton.rx.tap
            .map { Reactor.Action.didTapPhotoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: - State
        
        // 댓글 내용에 따른 색상 변화
        reactor.state
            .map { $0.content }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, content in
                owner.textView.text = content
                owner.textView.textColor =
                content == "내용을 입력해주세요" ? .customColor(.gray3) : .black
            })
            .disposed(by: disposeBag)
        
        // 카테고리 바인딩
        reactor.state
            .map { $0.category }
            .bind(to: titleNaviLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 제목 텍스트 바인딩
        reactor.state
            .map { $0.title }
            .compactMap { $0 }
            .map { text in
                if text.count > 20 {
                    let index = text.index(text.startIndex, offsetBy: 20)
                    return String(text[..<index])
                } else {
                    return text
                }
            }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, text in
                owner.titleTextField.text = text
                owner.titleCountLabel.text = "\(text.count)/20"
            })
            .disposed(by: disposeBag)
        
        // ok버튼 enable 설정
        reactor.state
            .map { $0.okButtonEnable }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isEnable in
                owner.okButton.isEnabled = isEnable
                if isEnable {
                    owner.okButton.setTitleColor(.black, for: .normal)
                } else {
                    owner.okButton.setTitleColor(.customColor(.gray3), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        // 앨범 창 열기
        reactor.state
            .map { $0.isPresentToAlbum }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                let selectionLimit = 6 - reactor.currentState.photoCount
                if selectionLimit == 0 {
                    owner.showAlert(title: "HMOA",
                                    message: "사진은 6개까지 업로드 할 수 있습니다",
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
        
        // 선택된 이미지 바인딩
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
        
        // pagecontrol 설정
        reactor.state
            .map { $0.photoCount }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, count in
                owner.pageControl.isHidden = false
                owner.pageControl.numberOfPages = count
            })
            .disposed(by: disposeBag)
        
        // 마지막 아이템 제거 시 그 전 아이템으로 이동
        reactor.state
            .map { $0.isDeletedLast }
            .distinctUntilChanged()
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isDeleted in
                let page = reactor.currentState.photoCount
                if page > 0 {
                    let targetIndexPath = IndexPath(row: page - 1, section: 0)
                    owner.collectionView.scrollToItem(at: targetIndexPath, at: .right, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CommunityWriteViewController: PHPickerViewControllerDelegate {
    
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
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = {(item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            self.pageControl.currentPage = index
            self.reactor?.action.onNext(.didChangePage(index))
        }
        
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
