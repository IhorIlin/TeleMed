//
//  DashboardTableViewCell.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 05.07.2025.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(model: DashboardUserModel) {
        var content = defaultContentConfiguration()
        content.text = model.email
        content.secondaryText = model.userRole.rawValue
        
        contentConfiguration = content
    }
}
