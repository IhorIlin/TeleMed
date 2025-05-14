//
//  AuthTextField.swift
//  TeleMed
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit

final class AuthTextField: UITextField {
    let customPadding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: customPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: customPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: customPadding)
    }
    
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        let height = customPadding.top + baseSize.height + customPadding.bottom
        
        return CGSize(width: baseSize.width, height: height)
    }
}
