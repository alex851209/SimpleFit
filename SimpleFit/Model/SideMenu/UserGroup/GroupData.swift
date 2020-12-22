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
    var name: String
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

struct Album: Codable {
    
    var id: String
    var name: String
    var url: String
    var createdTime: Date
}

struct Inviter: Codable {
    
    var name: String
    var avatar: String
}

struct Invitation: Codable {
    
    var id: String
    var name: String
    var inviter: Inviter
}
