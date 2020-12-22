//
//  ProgressHUDWrapper.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/22.
//

import Foundation
import ProgressHUD

class SFProgressHUD {
    
    static func showLoading() {
        
        ProgressHUD.colorStatus = .systemGray
        ProgressHUD.colorAnimation = .lightGray
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show("載入中...")
    }
    
    static func showSuccess() {
        
        ProgressHUD.colorAnimation = .lightGray
        ProgressHUD.showSucceed("成功")
    }
    
    static func dismiss() {
        
        ProgressHUD.dismiss()
    }
    
    static func showHeart() {
        
        ProgressHUD.colorStatus = .systemGray
        ProgressHUD.colorAnimation = UIColor(red: 168/255, green: 63/255, blue: 57/255, alpha: 1)
        ProgressHUD.show("加入收藏", icon: .heart, interaction: true)
    }
    
    static func removeHeart() {
        
        ProgressHUD.colorStatus = .systemGray
        ProgressHUD.colorAnimation = .lightGray
        ProgressHUD.show("移除收藏", icon: .heart, interaction: true)
    }
}
