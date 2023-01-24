//
//  StartViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/01/24.
//

import UIKit

import SnapKit
import Then

class StartViewController: UIViewController {
    
    //MARK: - Property
    let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
        나에게 꼭 맞는
        향수 추천을 위한
        3초
        """
        $0.font = .customFont(.pretendard, 30)
    }
    
    let explainLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = """
        출생연도와 성별을 설정하면, 나와 비슷한 사람들이
        찾아보는 향수를 추천받을 수 있어요
        """
        $0.font = .customFont(.pretendard, 14)
    }
    
    var selectYearButton: UIButton! = nil
    
    var womanButton: UIButton! = nil
    var manButton: UIButton! = nil
    
    let startButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .customColor(.searchBarColor)
        $0.titleLabel?.font = .customFont(.pretendard, 16)
        $0.setTitle("시작하기", for: .normal)
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setAddView()
        setUpConstraints()
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
        
        let yearConfig = setConfigurationButton(imageName: "downPolygon", title: "출생연도", isCorner: true)
        selectYearButton = UIButton(configuration: yearConfig)
        
        let womanConfig = setConfigurationButton(imageName: "circle.fill", title: "여성", isCorner: false)
        womanButton = UIButton(configuration: womanConfig)
        
        let manConfig = setConfigurationButton(imageName: "circle.fill", title: "남성", isCorner: false)
        manButton = UIButton(configuration: manConfig)

        startButton.addTarget(self, action: #selector(didTapStartButton(_: )), for: .touchUpInside)
        
    }
    
    private func setAddView() {
        [titleLabel, explainLabel, selectYearButton, womanButton, manButton, startButton].forEach { view.addSubview($0) }
    }
    
    private func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(106)
            make.leading.equalToSuperview().inset(20)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.height.equalTo(77)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        selectYearButton.snp.makeConstraints { make in
            make.width.equalTo(184)
            make.height.equalTo(51)
            make.top.equalTo(explainLabel.snp.bottom).offset(59)
            make.leading.equalToSuperview().inset(20)
        }
        
        womanButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(selectYearButton.snp.bottom).offset(51)
            make.height.equalTo(31)
        }
        
        manButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(130)
            make.top.equalTo(selectYearButton.snp.bottom).offset(51)
            make.height.equalTo(31)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(66)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setConfigurationButton(imageName: String, title: String, isCorner: Bool) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(title)
        config.attributedTitle?.foregroundColor = .black
        config.attributedTitle?.font = .customFont(.pretendard, 24)
        
        if isCorner {
            config.background.backgroundColor = .customColor(.searchBarColor)
            config.image = UIImage(named: imageName)
            config.imagePlacement = .trailing
            config.titleAlignment = .leading
            config.imagePadding = 50
            config.cornerStyle = .medium
        } else {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 32)
            config.image = UIImage(systemName: imageName)
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            config.imagePadding = 7
            config.preferredSymbolConfigurationForImage = imageConfig
            config.baseForegroundColor = .customColor(.searchBarColor)
        }
        
        return config
    }
    
    
    //MARK: - Function
    @objc private func didTapStartButton(_ sender: UIButton) {
        let tabBar = AppTabbarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}
