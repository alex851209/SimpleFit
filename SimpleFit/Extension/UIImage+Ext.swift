//
//  UIImage+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit

enum ImageAsset: String {
    
    // HomeVC
    case sideMenu = "line.horizontal.3"
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? { return UIImage(named: asset.rawValue) }
    
    static func systemAsset(_ asset: ImageAsset) -> UIImage? { return UIImage(systemName: asset.rawValue) }
}
