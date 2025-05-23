//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Danil Otmakhov on 17.04.2025.
//

import UIKit

extension UIColor {
    
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    convenience init?(from hexString: String) {
        var cleanedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cleanedHexString.hasPrefix("#") {
            cleanedHexString.remove(at: cleanedHexString.startIndex)
        }
        
        guard cleanedHexString.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: cleanedHexString).scanHexInt64(&rgbValue) else { return nil }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func isEqual(to otherColor: UIColor) -> Bool {
        hexString == otherColor.hexString
    }
    
}
