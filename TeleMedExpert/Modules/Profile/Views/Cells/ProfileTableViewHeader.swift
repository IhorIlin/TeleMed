//
//  ProfileTableViewHeader.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 09.06.2025.
//

import UIKit
import SDWebImage

class ProfileTableViewHeader: UIView {
    private let avatarImageContainerView = UIView()
    let userAvatarImageView = UIImageView()
    let userNameLabel = UILabel()
    let userRoleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented!")
    }

    private func setupViews() {
        configureAvatarImageContainerView()
        configureUserAvatarImageView()
        configureUserNameLabel()
        configureUserRoleLabel()
    }
    
    private func configureAvatarImageContainerView() {
        avatarImageContainerView.layer.cornerRadius = 50
        avatarImageContainerView.layer.shadowColor = ColorPalette.Shadow.secondaryShadow?.cgColor
        avatarImageContainerView.layer.shadowRadius = 8
        avatarImageContainerView.layer.shadowOpacity = 1
        avatarImageContainerView.layer.shadowOffset = .zero
        
        addSubview(avatarImageContainerView)
    }
    
    private func configureUserAvatarImageView() {
        userAvatarImageView.layer.cornerRadius = 50
        userAvatarImageView.layer.borderColor = ColorPalette.Border.borderActive?.cgColor
        userAvatarImageView.layer.borderWidth = 2
        
        avatarImageContainerView.addSubview(userAvatarImageView)
    }
    
    private func configureUserNameLabel() {
        userNameLabel.font = Font.TextStyle.titleLarge()
        userNameLabel.textColor = ColorPalette.Text.primary
        
        addSubview(userNameLabel)
    }
    
    private func configureUserRoleLabel() {
        userRoleLabel.font = Font.TextStyle.titleMedium()
        userRoleLabel.textColor = ColorPalette.Text.secondary
        
        addSubview(userRoleLabel)
    }
    
    private func setupConstraints() {
        avatarImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.height.equalTo(100)
        }
        
        userAvatarImageView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageContainerView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        userRoleLabel.translatesAutoresizingMaskIntoConstraints = false
        userRoleLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
