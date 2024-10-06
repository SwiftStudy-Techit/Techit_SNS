//
//  Comment.swift
//  TechitSNS
//
//  Created by 김동경 on 10/6/24.
//

import Foundation

struct Comment: Codable {
    var commentId: String = UUID().uuidString
    var writerUid: String = ""
    var writerName: String = ""
    var writerProfileUrl: String = ""
    var createAt: Date = Date()
    var comment: String
}
