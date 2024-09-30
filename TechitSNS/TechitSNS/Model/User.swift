//
//  User.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation


struct User: Hashable, Codable{
//    var id = UUID()
    var userUid: String
    var profileUrl: String
    var statusMessage: String
    var userEmail: String
    var userId: String
    var userName: String
    //var nickname: String
}

