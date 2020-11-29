//
//  SideMenuItemManager.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit

enum SideMenuItem {

    case user
    case friend
    case favorite
    case review
    case goal

    var image: UIImage? {

        switch self {
        
        case .user: return UIImage(named: "user")
        case .friend: return UIImage(named: "friend")
        case .favorite: return UIImage(named: "favorite")
        case .review: return UIImage(named: "review")
        case .goal: return UIImage(named: "goal")
        }
    }

    var title: String {

        switch self {
        
        case .user: return "個人"
        case .friend: return "好友"
        case .favorite: return "收藏"
        case .review: return "里程碑"
        case .goal: return "目標"
        }
    }
}

class SideMenuItemManager {
    
    static let sideMenuItems: [SideMenuItem] = [.user, .friend, .favorite, .review, .goal]
}
