//
//  UIImage+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit

enum ImageAsset: String {
    
    // HomeVC
    case sideMenu = "menu"
    case add = "add_menu"
    case weight = "weight"
    case camera = "camera"
    case album = "album"
    case note = "note"
    
    // DetailVC
    case remove = "remove"
    
    // UserInfoVC
    case edit = "edit"
    case confirm = "check"
    
    // User
    case person = "user_photo"
}

enum SystemImageAsset: String {
 
    // UserBoardVC
    case time = "clock"
    case heart = "heart.circle"
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? { return UIImage(named: asset.rawValue) }
    
    static func systemAsset(_ asset: SystemImageAsset) -> UIImage? { return UIImage(systemName: asset.rawValue) }
    
    func scale(newWidth: CGFloat) -> UIImage {
        
        // Make sure the given width is different from the existing one
        if self.size.width == newWidth {
            return self
        }
        
        // Calculate the scaling factor
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
