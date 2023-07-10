//
//  ChangeProfileImageViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/07/02.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher
import PhotosUI

class ChangeProfileImageViewController: UIViewController, View {

    // MARK: - UI Component
    typealias Reactor = ChangeProfileImageReactor
    var disposeBag = DisposeBag()
    
    lazy var profileImageView: UIImageView = UIImageView().then {
        $0.backgroundColor = .customColor(.gray3)
        $0.layer.cornerRadius = 25
    }
    
    lazy var showAlbumButton: UIButton = UIButton().then {
        var configure = UIButton.Configuration.plain()
        var attributedString = AttributedString.init("사진 선택")
        attributedString.font = .customFont(.pretendard_light, 14)
        
        configure.baseForegroundColor = .white
        configure.attributedTitle = attributedString
        
        $0.configuration = configure
        $0.backgroundColor = .black
    }
    
    lazy var changeButton: UIButton = UIButton().then {
        $0.setProfileChangeBottomView()
    }
    

    var pickerViewConfig: PHPickerConfiguration = {
       var config = PHPickerConfiguration()
        config.filter = .images
        
        return config
    }()
    
    lazy var pickerView: PHPickerViewController = {
       
        let pickerView = PHPickerViewController(configuration: pickerViewConfig)
        
        return pickerView
    }()
    
    var tqwe: UILabel = {
       var label = UILabel()
        
        return label
    }()
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("프로필 이미지")
        configureUI()
    }
}

extension ChangeProfileImageViewController {
    
    
    // MARK: - bind
    
    func bind(reactor: ChangeProfileImageReactor) {
        
        // action
        
        // 사진 선택 버튼 클릭
        showAlbumButton.rx.tap
            .map { Reactor.Action.didTapShowAlbumButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 변경 버튼 클릭
        
        changeButton.rx.tap
            .map { Reactor.Action.didTapChangeButton(reactor.currentState.profileImage!)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // state
        
        // 프로필 이미지 바인딩
        reactor.state
            .map { $0.profileImage }
            .distinctUntilChanged()
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        // 앨범 화면 띄우기
        reactor.state
            .map { $0.isShowAlbum }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: {
                self.present(self.pickerView, animated: true)
            })
            .disposed(by: disposeBag)
            
        // 변경버튼 클릭시 뒤로가기
        reactor.state
            .map { $0.isDismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    func configureUI() {
        
        view.backgroundColor = .white
        pickerView.delegate = self
        
        [
            profileImageView,
            showAlbumButton,
            changeButton
        ]   .forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(50)
        }
        
        showAlbumButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.width.equalTo(100)
        }
        
        changeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ChangeProfileImageViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let cg = CoreGraphicManager()
        
        let itemProvider = results.first?.itemProvider
        
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let url {
                    let targetSize = CGSize(width: 80, height: 80)
                    
                    guard let downsampledImageData = cg.downsample(
                        imageAt: url,
                        to: targetSize,
                        scale: UIScreen.main.scale) else { return }
                                        
                    self.reactor?.action.onNext(.didSelectedImage(downsampledImageData))
                }
                
                DispatchQueue.main.async {
                    picker.dismiss(animated: true)
                    self.setEnableChangeButton()
                }
            }
        }
    }
}

extension ChangeProfileImageViewController {
    
    func setEnableChangeButton() {
        changeButton.backgroundColor = .black
        changeButton.isEnabled = true
    }
}
