//
//  LoginViewModel.swift
//  TechitSNS
//
//  Created by 김효정 on 9/18/24.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
class LoginViewModel {
    var user = User(userEmail: "", userId: "", password: "", userName: "", profileUrl: "", statusMessage: "", userUid: "")
    var isLoggedIn: Bool = false // 로그인 성공 여부를 나타내는 상태 변수
    var errorMessage: String? // 로그인 에러 메시지를 저장
    
    func login() async throws ->  String {
        do {
            // Firebase로 로그인 시도
            // signIn 함수가 완료될 때까지 기다려!
            let result = try await Auth.auth().signIn(withEmail: user.userEmail, password: user.password)
            isLoggedIn = true // 로그인 성공 상태로 변경
            errorMessage = nil // 로그인 성공 시 에러 메시지 초기화
            return result.user.uid //대충 로그인 성공했다는 뜻(uid반환)
        } catch let error as NSError {
            // 콘솔에 오류 코드 출력 (디버깅용)
            print("로그인 실패: \(error.code) - \(error.localizedDescription)")
            
            // 에러 처리
            switch error.code {
            case AuthErrorCode.wrongPassword.rawValue:
                errorMessage = "비밀번호 오류"
                
            case AuthErrorCode.userNotFound.rawValue:
                errorMessage = "계정을 찾을 수 없음"
                
            case AuthErrorCode.invalidEmail.rawValue:
                errorMessage = "올바르지 않은 이메일 형식"
                
            default:
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
}
