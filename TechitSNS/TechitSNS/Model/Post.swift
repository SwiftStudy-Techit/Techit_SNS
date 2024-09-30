//
//  Post.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import Foundation

struct Post: Hashable, Codable{
//    var id = UUID()
    var writerUid: String
    var date: Date
    var imageURL: String
    var postId: String
    var text: String
    var writerName: String
    var writerProfileUrl: String
}
