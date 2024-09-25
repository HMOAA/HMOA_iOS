//
//  OrderCancelLogViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/25/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderCancelLogViewController: UIViewController, View {

    // MARK: - UI Components


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

    func bind(reactor: OrderCancelLogReactor) {

        // MARK: Action

        // MARK: State
    }

    // MARK: - Functions

    private func setUI() {
        setClearBackNaviBar("환불 / 반품 내역", .black)
        view.backgroundColor = .white
    }

    // MARK: Add Views
    private func setAddView() {

    }

    // MARK: Set Constraints
    private func setConstraints() {

    }

}
