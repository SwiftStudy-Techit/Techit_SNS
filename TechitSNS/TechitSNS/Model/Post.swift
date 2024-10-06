//
//  Post.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation


struct Post: Codable {
    var postId: String = UUID().uuidString
    var imagesUrl: [String] = []
    var date: Date = Date()
    var text: String
    var writerUid: String = ""
    var writerProfileUrl: String = ""
    var writerName: String = ""
    var commentCount: Int = 0
}
