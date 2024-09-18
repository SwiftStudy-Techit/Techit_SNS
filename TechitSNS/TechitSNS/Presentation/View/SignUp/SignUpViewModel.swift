//
//  SignUpViewModel.swift
//  TechitSNS
//
//  Created by 김효정 on 9/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class SignUpViewModel {
    var user = User(userEmail: "", userId: "", password: "", userName: "", profileUrl: "", statusMessage: "", userUid: "")
    
    private let db = Firestore.firestore() // Firestore 인스턴스 생성
    
    func signUp() async throws -> String {
        do {
            //회원가입 결과를 기다릴게
            let result = try await Auth.auth().createUser(withEmail: user.userEmail, password: user.password)
            user.userUid = result.user.uid // Firebase Authentication으로부터 UID를 받아옴
            
            // Firestore에 사용자 정보 저장
            try await saveUserData()
            
            // Firestore 저장 후 UID 반환
            return result.user.uid
        } catch {
            print("\(error.localizedDescription)")
            throw error // 에러났음 에러 던질게
        }
    }
    
    // Firestore에 사용자 데이터를 저장하는 함수
    private func saveUserData() async throws {
        // 저장할 데이터 구성
        let userData: [String: Any] = [
            "userId": user.userId,
            "userEmail": user.userEmail,
            "userName": user.userName,
            "profileUrl": user.profileUrl,
            "statusMessage": user.statusMessage,
            "userUid": user.userUid
        ]
        
        // Firestore에 데이터 저장 (users 컬렉션에 UID를 문서 ID로 설정)
        try await db.collection("users").document(user.userUid).setData(userData)
    }
}
