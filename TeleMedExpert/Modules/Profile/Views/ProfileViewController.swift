//
//  ProfileViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 04.06.2025.
//

import UIKit
import SnapKit
import Combine

class ProfileViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: ProfileViewModel
    
    var logoutAction: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ProfileViewController deinited")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        setupConstraints()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadUserProfileInfo()
    }
    
    private func setupViews() {
        navigationItem.title = "Profile"
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.dataSource = self
        tableView.delegate = self
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
    
    private func bindViewModel() {
        viewModel.subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .logout:
                    self?.logoutAction?()
                case .showEditProfile: break
                    // TODO: show edit profile screen
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableViewDelegate/DataSource -
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileTableViewCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ProfileTableViewHeader()
        
        header.userNameLabel.text = "Ihor Ilin"
        header.userRoleLabel.text = "Doctor"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            viewModel.logout()
        }
    }
}
