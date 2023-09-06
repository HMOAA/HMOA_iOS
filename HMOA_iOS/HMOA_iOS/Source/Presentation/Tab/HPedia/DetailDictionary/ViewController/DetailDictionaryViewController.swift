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
        $0.setLabelUI("샬라샬라", font: .pretendard_semibold, size: 16, color: .black)
    }
    
    let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.setLabelUI("""
1
2
3
4
5
6
7
8
9
""", font: .pretendard, size: 16, color: .black)
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
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(explainLabel.snp.bottom).offset(19)
        }
    }
    
    
    
}
