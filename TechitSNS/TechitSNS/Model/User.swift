//
//  User.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation


struct User: Codable {
    var userEmail: String
    var userId: String
    var password: String
    var userName: String
    var profileUrl: String
    var statusMessage: String
    var userUid: String
}
