//
//  DetailDictionaryViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 2023/09/06.
//

import UIKit

import ReactorKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class DetailDictionaryViewController: UIViewController {

    let titleEnglishLabel = UILabel().then {
        $0.setLabelUI("TopNote", font: .pretendard_semibold, size: 30, color: .black)
    }
    
    let titleKoreanLabel = UILabel().then {
        $0.setLabelUI(": 탑 노트", font: .pretendard, size: 20, color: .black)
    }
    
    let explainLabel = UILabel().then {
        $0.setLabelUI("사전 정의", font: .pretendard_semibold, size: 16, color: .black)
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabelUI("노트란 향에 대한 느낌을 말하는 것으로, 발향 순서에 따라 톱 노트, 미들 노트, 베이스 노트로 나뉜다. 이러한 분류는 여러 종류의 향을 배합할 때 각각의 느낌을 조화롭게 하기 위해 꼭 필요하다. 에센셜 오일 역시 한 가지만 사용하는 것보다는 두세 종류의 오일을 조합하는 경우가 많으므로, 각각의 오일이 갖고 있는 노트를 파악하고 있으면 자신이 좋아하는 향을 조합해 사용할 수 있다.", font: .pretendard, size: 16, color: .black)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setNavigationBarTitle(title: "dd", color: .white, isHidden: false)
        setAddView()
        setConstraints()

    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.backgroundColor = .white
    }
    
    private func setAddView() {
        [
            titleEnglishLabel,
            titleKoreanLabel,
            explainLabel,
            contentLabel
        ]   .forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        titleEnglishLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        titleKoreanLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleEnglishLabel.snp.bottom).offset(12)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleKoreanLabel.snp.bottom).offset(60)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(explainLabel.snp.bottom).offset(19)
        }
    }
    
    
    
}
