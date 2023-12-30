//
//  TutorialViewController.swift
//  HMOA_iOS
//
//  Created by 정지훈 on 12/15/23.
//

import UIKit

import Then
import SnapKit
import RxCocoa
import RxSwift

class TutorialViewController: UIPageViewController {

    private var pages = [UIViewController]()
    let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        $0.currentPageIndicatorTintColor = .black
        $0.numberOfPages = 4
    }
    
    let xButton = UIButton().then {
        $0.setImage(UIImage(named: "x"), for: .normal)
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPage()
        setUpUI()
        bind()
    }
    
    private func setUpPage() {
        let firstPage = TutorialContentViewController(
            title: """
            당신을 위한 모든 향을 모아서,
            HMOA
            """,
            content: """
            내 손 안에 향기를 담다.
            생생한 향수 정보 제공 어플입니다.
            """,
            imageName: "firstTutorial")
        
        let secondPage = TutorialContentViewController(
            title: """
            향기를 바꾸는 STORY,
            향수 정보를 확인할 수 있어요.
            """,
            content: """
            향모아에서 모든 향수의 정보를 확인하세요
            오로지 향수에만 집중했습니다.
            """,
            imageName: "secondTutorial")
        
        let thirdPage = TutorialContentViewController(
            title: """
            여러분의 의견을
            향모아에서 직접 투표해주세요.
            """,
            content: """
            향수와 어울리는 계절, 성별, 연령대를
            투표할 수 있습니다.
            """,
            imageName: "thirdTutorial")
        
        
        
        let fourthPage = TutorialContentViewController(
            title: """
            자유롭게 여러분의
            생각을 나눠보세요.
            """,
            content: """
            H피디아에서 다양한 정보를 얻고,
            QnA에서 향수에 관한 질문을 해보세요.
            """,
            imageName: "fourthTutorial")
        
        pages = [firstPage, secondPage, thirdPage, fourthPage]
    }
    
    //MARK: - SetUp
    private func setUpUI() {
        view.addSubview(pageControl)
        view.addSubview(xButton)
        
        view.backgroundColor = #colorLiteral(red: 0.9593991637, green: 0.9593990445, blue: 0.9593991637, alpha: 1)
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            make.centerX.equalToSuperview()
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(32)
        }
        
        delegate = self
        dataSource = self
        setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    private func bind() {
        xButton.rx.tap
            .bind(with: self) { owner, _ in
                UserDefaults.standard.set(true, forKey: "Tutorial")
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension TutorialViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    // 이전 뷰컨트롤러를 리턴 (우측 -> 좌측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        pageControl.currentPage = currentIndex
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    // 다음 보여질 뷰컨트롤러를 리턴 (좌측 -> 우측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        pageControl.currentPage = currentIndex
        guard currentIndex < (pages.count - 1) else { return nil }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers,
              let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
