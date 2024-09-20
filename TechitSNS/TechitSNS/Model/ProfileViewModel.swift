//
//  ViewModel.swift
//  TechitSNS
//
//  Created by 홍지수 on 9/19/24.
//

import Firebase
import FirebaseStorage
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile: User?
    @Published var posts: [Post] = []
    
    private let db = Firestore.firestore()

    // 사용자 프로필 데이터 가져오기
    func fetchUserProfile(userID: String) {
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let userUid = data?["password"] as? String ?? "Uid"
                let password = data?["password"] as? String ?? "비밀번호"
                let profileUrl = data?["profileUrl"] as? String ?? "프로필"
                let statusMessage = data?["statusMessage"] as? String ?? "상태 메시지"
                let userEmail = data?["userEmail"] as? String ?? "이메일"
                let userId = data?["userId"] as? String ?? "아이디"
//                let userName = data?["userName"] as? String ?? "사용자 이름"
                //let userUid = data?["userUid"] as? UUID ?? "사용자 Uid"
//                let nickname = data?["nickname"] as? String ?? "사용자 이름"
//                let profileImageURL = data?["profileImageURL"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.userProfile = User(userUid: userUid, password: password, profileUrl: profileUrl, statusMessage: statusMessage, userEmail: userEmail, userId: userId)
                }
            }
        }
    }
    
    
    // 사용자 게시물 데이터 가져오기
    func fetchUserPosts(userID: String) {
        db.collection("users").document(userID).collection("posts").getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let postsData = querySnapshot.documents.map { document -> Post in
                    let data = document.data()
//                    let date = data["date"] as? Date ??
                    let writerUid = data["writerUid"] as? String ?? ""
                    let imageURL = data["imageURL"] as? String ?? ""
                    let postId = data["postId"] as? String ?? ""
                    let text = data["bodyText"] as? String ?? ""
                    let writerName = data["writerName"] as? String ?? ""
                    let writerProfileUrl = data["writerProfileUrl"] as? String ?? ""
                    return Post(writerUid: writerUid, imageURL: imageURL, postId: postId, text: text, writerName: writerName, writerProfileUrl: writerProfileUrl)
                }
                
                DispatchQueue.main.async {
                    self.posts = postsData
                }
            }
        }
    }
}
