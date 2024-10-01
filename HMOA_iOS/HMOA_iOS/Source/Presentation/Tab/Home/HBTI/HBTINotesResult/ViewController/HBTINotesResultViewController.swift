//
//  HBTINotesResultViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then

final class HBTINotesResultViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView = HBTINotesResultHeaderView()
    
    private lazy var tableView = UITableView(frame: .zero).then {
        $0.register(HBTINotesResultCell.self, forCellReuseIdentifier: HBTINotesResultCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.allowsSelection = false
    }
    
    private let footerView = HBTINotesResultFooterView()
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton()
    
    // MARK: - Properties
    
    private let selectedNotes: [HBTINotesResultModel]
    
    // MARK: - Initialization
    
    init(selectedNotes: [HBTINotesResultModel] = HBTINotesResultModel.notesResultData) {
        self.selectedNotes = selectedNotes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTISurveyReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         headerView,
         tableView,
         footerView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(footerView.snp.top).offset(-8)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
    
    // MARK: Configure DataSource
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HBTINotesResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HBTINotesResultCell.reuseIdentifier, for: indexPath) as? HBTINotesResultCell else {
            fatalError("Unable to dequeue HBTINotesResultCell")
        }
        cell.configure(with: selectedNotes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
}
