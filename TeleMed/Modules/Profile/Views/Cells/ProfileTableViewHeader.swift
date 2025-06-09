//
//  ProfileTableViewHeader.swift
//  TeleMed
//
//  Created by Ihor Ilin on 09.06.2025.
//

import UIKit
import SDWebImage

class ProfileTableViewHeader: UIView {

    private let userAvatarImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userRoleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented!")
    }

    private func setupViews() {
        configureUserAvatarImageView()
        configureUserNameLabel()
        configureUserRoleLabel()
    }
    
    private func configureUserAvatarImageView() {
        userAvatarImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage())
    }
    
    private func configureUserNameLabel() {
        
    }
    
    private func configureUserRoleLabel() {
        
    }
    
    private func setupConstraints() {
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.snp.makeConstraints { make in
            
        }
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.snp.makeConstraints { make in
            
        }
        
        userRoleLabel.translatesAutoresizingMaskIntoConstraints = false
        userRoleLabel.snp.makeConstraints { make in
            
        }
    }
}
