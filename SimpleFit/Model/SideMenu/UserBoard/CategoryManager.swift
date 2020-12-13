//
//  CategoryManager.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/13.
//

import Foundation

enum CategoryItem {

    case problem
    case advice
    case reflection
    case discussion
    case chat
    case info

    var title: String {

        switch self {
        
        case .problem: return "問題"
        case .advice: return "建議"
        case .reflection: return "心得"
        case .discussion: return "討論"
        case .chat: return "閒聊"
        case .info: return "情報"
        }
    }
}

class CategoryManger {
    
    static let categoryItems: [CategoryItem] = [.problem, .advice, .reflection, .discussion, .chat, .info]
}
