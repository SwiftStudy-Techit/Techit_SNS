//
//  User.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation


// 로그인과 회원가입에 필요한 데이터
struct UserDTO: Codable {
    var userEmail: String
    var userId: String
    var password: String
    var userName: String
    var profileUrl: String
    var statusMessage: String
    var userUid: String
}

struct UserDTO2: Codable {
    var userEmail: String
    var userId: String
    var userName: String
    var profileUrl: String
    var statusMessage: String
    var userUid: String
}
