//
//  GroupData.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import Foundation

struct Group: Codable {
    
    var id: String
    var coverPhoto: String
    var title: String
    var content: String
    var category: String
    var owner: Owner = Owner(name: "", avatar: "")
}

struct Owner: Codable {
    
    var name: String = ""
    var avatar: String = ""
}

struct Challenge: Codable {
    
    var id: String
    var avatar: String?
    var content: String
    var date: String
}
