//
//  SideMenuItemManager.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit

enum SideMenuItem {

    case user
//    case board
    case group
    case favorite
    case review
    case goal

    var image: UIImage? {

        switch self {
        
        case .user: return UIImage(named: "user")
//        case .board: return UIImage(named: "friend")
        case .group: return UIImage(named: "friend")
        case .favorite: return UIImage(named: "favorite")
        case .review: return UIImage(named: "review")
        case .goal: return UIImage(named: "goal")
        }
    }

    var title: String {

        switch self {
        
        case .user: return "個 人"
//        case .board: return "討論區"
        case .group: return "群 組"
        case .favorite: return "收 藏"
        case .review: return "回 顧"
        case .goal: return "目 標"
        }
    }
}

class SideMenuItemManager {
    
    static let sideMenuItems: [SideMenuItem] = [.user, .group, .favorite, .review, .goal]
}
