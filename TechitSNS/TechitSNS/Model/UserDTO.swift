//
//  User.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation


struct UserDTO: Codable {
    var userEmail: String
    var userId: String
    var userName: String
    var profileUrl: String
    var statusMessage: String
    var userUid: String
}
