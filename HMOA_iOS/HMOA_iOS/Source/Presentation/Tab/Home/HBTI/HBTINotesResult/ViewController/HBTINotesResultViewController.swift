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
    
    private lazy var tableView = UITableView().then {
        $0.register(HBTINotesResultCell.self, forCellReuseIdentifier: HBTINotesResultCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.backgroundColor = .customColor(.gray1)
    }
    
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
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         tableView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(173)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(500)
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
}
