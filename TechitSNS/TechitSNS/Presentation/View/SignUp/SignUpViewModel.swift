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
    var user = UserDTO(userEmail: "", userId: "", userName: "", profileUrl: "", statusMessage: "", userUid: "")
    
    var isEmailValid: Bool = true // 이메일 형식 검증 상태
    var emailErrorMessage: String? = nil // 이메일 오류 메시지
    
    private let db = Firestore.firestore() // Firestore 인스턴스 생성
    
    // 이메일 형식 검증 함수
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: user.userEmail)
        
        if isEmailValid {
            emailErrorMessage = nil
        } else {
            emailErrorMessage = "올바르지 않은 이메일 형식입니다."
        }
    }
    
    // password는 인자로 받기
    func signUp(password: String) async throws -> String {
        do {
            //회원가입 결과를 기다릴게
            let result = try await Auth.auth().createUser(withEmail: user.userEmail, password: password)
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
        try await db.collection("Users").document(user.userUid).setData(userData)
    }
}
