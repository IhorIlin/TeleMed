import UIKit

enum ColorPalette {

    // MARK: - Backgrounds
    enum Background {
        static let primary   = UIColor(hex: "#F9FAFB") // Soft white
        static let secondary = UIColor(hex: "#FFFFFF") // Pure white
        static let screen    = UIColor(hex: "#F2F2F7") // Neutral light gray
    }

    // MARK: - Text
    enum Text {
        static let primary     = UIColor(hex: "#1C1C1E") // Near-black
        static let secondary   = UIColor(hex: "#6B7280") // Cool gray
        static let placeholder = UIColor(hex: "#9CA3AF") // Light gray
        static let inverted    = UIColor(hex: "#FFFFFF")
    }

    // MARK: - Buttons
    enum Button {
        static let primaryBackground   = UIColor(hex: "#4F46E5") // Indigo
        static let primaryText         = UIColor(hex: "#FFFFFF")
        static let secondaryBackground = UIColor(hex: "#E5E7EB") // Soft gray
        static let secondaryText       = UIColor(hex: "#4B5563") // Dark gray
        static let disabledBackground  = UIColor(hex: "#D1D5DB") // Very light gray
        static let disabledText        = UIColor(hex: "#9CA3AF")
    }

    // MARK: - Inputs
    enum Input {
        static let border     = UIColor(hex: "#D1D5DB") // Light border gray
        static let background = UIColor(hex: "#FFFFFF")
        static let text       = Text.primary
    }

    // MARK: - Alerts
    enum Alert {
        static let error   = UIColor(hex: "#EF4444") // Red
        static let warning = UIColor(hex: "#F59E0B") // Orange
        static let success = UIColor(hex: "#10B981") // Green
        static let info    = UIColor(hex: "#3B82F6") // Blue
    }

    // MARK: - Links
    enum Link {
        static let primary = UIColor(hex: "#4F46E5") // Indigo
        static let visited = UIColor(hex: "#6366F1") // Lighter indigo
    }

    // MARK: - Navigation / TabBar
    enum Navigation {
        static let barBackground = Background.primary
        static let tint          = Link.primary
    }
    
    // MARK: - Shadows
    enum Shadow {
        static let primaryShadow = UIColor(hex: "#000000", alpha: 0.1)
    }
    
    // MARK: - Borders
    enum Border {
        static let borderPrimary = UIColor(hex: "#D1D5DB") // Soft cool gray (Tailwind's `gray-300`)
        static let borderActive = UIColor(hex: "#4F46E5") // Indigo
    }
}
