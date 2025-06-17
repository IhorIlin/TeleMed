import UIKit

enum ColorPalette {
    
    // MARK: - Backgrounds
    enum Background {
        static let primary   = UIColor(named: "BackgroundPrimary")
        static let secondary = UIColor(named: "BackgroundSecondary")
    }
    
    // MARK: - Text
    enum Text {
        static let primary     = UIColor(named: "TextPrimary")
        static let secondary   = UIColor(named: "TextSecondary")
        static let placeholder = UIColor(named: "TextPlaceholder")
    }
    
    // MARK: - Buttons
    enum Button {
        static let indigo       = UIColor(named: "ButtonIndigo")
        static let vibrantGreen = UIColor(named: "ButtonVibrantGreen")
        static let primaryText  = UIColor(named: "ButtonPrimaryText")
    }
    
    // MARK: - Links
    enum Link {
        static let primary = UIColor(named: "LinkPrimary")
    }
    
    // MARK: - Shadows
    enum Shadow {
        static let primaryShadow   = UIColor(named: "ShadowPrimary")
        static let secondaryShadow = UIColor(named: "ShadowSecondary")
    }
    
    // MARK: - Borders
    enum Border {
        static let borderPrimary = UIColor(named: "BorderPrimary")
        static let borderActive = UIColor(named: "BorderActive")
    }
}
