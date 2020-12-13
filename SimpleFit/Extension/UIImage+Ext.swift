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
}

enum SystemImageAsset: String {
 
    // UserBoardVC
    case time = "clock"
    case heart = "heart.circle"
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? { return UIImage(named: asset.rawValue) }
    static func systemAsset(_ asset: SystemImageAsset) -> UIImage? { return UIImage(systemName: asset.rawValue) }
}
