//
//  DashboardViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit
import Combine

class DashboardViewController: UIViewController {
    private let viewModel: DashboardViewModel
    private var users: [DashboardUserModel] = []
    
    private var tableView = UITableView()
    
    var startCallCallback: ((UUID) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impemented!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        setupConstraints()
        
        bindViewModel()
        
        viewModel.getAllUsers()
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureUI() {
        navigationItem.title = "Dashboard"
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(DashboardTableViewCell.self,
                           forCellReuseIdentifier: String(describing: DashboardTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .usersLoaded(let users):
                    self?.users = users
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    // TODO: - Adopt to call for specific user from table list -
    @objc
    func startCall(userId: UUID) {
        startCallCallback?(userId)
    }
    
    deinit {
        print("DashboardViewController deinited")
    }
}

// MARK: - TableViewDelegate/DataSource -
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DashboardTableViewCell.self), for: indexPath) as? DashboardTableViewCell {
            cell.configureCell(model: users[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        
        startCallCallback?(selectedUser.userId)
    }
}
