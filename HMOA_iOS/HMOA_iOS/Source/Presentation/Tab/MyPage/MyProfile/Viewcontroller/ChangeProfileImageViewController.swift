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
    
    lazy var changeProfileImageButton: UIButton = UIButton().then {
        $0.setImage(UIImage(named: "addProfile"), for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 36
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
    
    lazy var nicknameView = NicknameView("변경")
    
    var tqwe: UILabel = {
       var label = UILabel()
        
        return label
    }()
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackItemNaviBar("프로필 수정")
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frame = nicknameView.nicknameTextField.frame
        setBottomBorder(nicknameView.nicknameTextField,
                        width: frame.width,
                        height: frame.height)
    }
}

extension ChangeProfileImageViewController {
    
    
    // MARK: - bind
    
    func bind(reactor: ChangeProfileImageReactor) {
        
        // action
        
        // 사진 선택 버튼 클릭
        changeProfileImageButton.rx.tap
            .map { Reactor.Action.didTapChangeProfileImageButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 변경 버튼 클릭
        nicknameView.bottomButton.rx.tap
            .map { Reactor.Action.didTapChangeButton(reactor.currentState.profileImage!)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nicknameView.duplicateCheckButton.rx.tap
            .map { Reactor.Action.didTapDuplicateButton(self.nicknameView.nicknameTextField.text)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        //textfield return 터치 이벤트
        nicknameView.nicknameTextField.rx.controlEvent(.editingDidEndOnExit)
            .map { ChangeProfileImageReactor.Action.didTapTextFieldReturn}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //닉네임 캡션 라벨 변경
        reactor.state
            .map { $0.isDuplicate }
            .compactMap { $0 }
            .bind(with: self) { owner, isDuplicate in
                owner.view.endEditing(true)
                owner.changeCaptionLabelColor(isDuplicate)
            }.disposed(by: disposeBag)
        
        //버튼 enable 상태 변경
        reactor.state
            .map { $0.isEnable }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { isEnable in
                DispatchQueue.main.async {
                    self.changeNextButtonEnable(isEnable)
                }
            }).disposed(by: disposeBag)
        
        //return 터치 시 키보드 내리기
        reactor.state
            .map { $0.isTapReturn }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { _ in
                self.nicknameView.nicknameTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        // 이전 화면으로 pop
        reactor.state
            .map { $0.nicknameResponse }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .map { _ in }
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
            
        // 기존 닉네임 바인딩
        reactor.state
            .map { $0.currentNickname }
            .distinctUntilChanged()
            .bind(to: nicknameView.nicknameTextField.rx.text)
            .disposed(by: disposeBag)

        // state
        
        // 프로필 이미지 바인딩
        reactor.state
            .map { $0.profileImage }
            .distinctUntilChanged()
            .bind(to: changeProfileImageButton.rx.image(for: .normal))
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
            changeProfileImageButton,
            nicknameView
        ]   .forEach { view.addSubview($0) }
        
        changeProfileImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(38)
            $0.width.height.equalTo(72)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(changeProfileImageButton.snp.bottom).offset(72)
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
        nicknameView.bottomButton.backgroundColor = .black
        nicknameView.bottomButton.isEnabled = true
    }
    
    //caption ui 변경
    private func changeCaptionLabelColor(_ isDuplicate: Bool) {
        if isDuplicate {
            nicknameView.nicknameCaptionLabel.text = "사용할 수 없는 닉네임 입니다."
            nicknameView.nicknameCaptionLabel.textColor = .customColor(.red)
        } else if !isDuplicate {
            nicknameView.nicknameCaptionLabel.text = "사용할 수 있는 닉네임 입니다."
            nicknameView.nicknameCaptionLabel.textColor = .customColor(.blue)
        }
    }
    
    //다음 버튼 ui변경
    private func changeNextButtonEnable(_ isEnable: Bool) {
        if isEnable  {
            self.nicknameView.bottomButton.isEnabled = true
            self.nicknameView.bottomButton.backgroundColor = .black
        } else {
            self.nicknameView.bottomButton.isEnabled = false
            self.nicknameView.bottomButton.backgroundColor = .customColor(.gray2)
        }
    }
    
    //빈 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
}
