//
//  AuthManager.swift
//  TechitSNS
//
//  Created by 김효정 on 9/30/24.
//

import Foundation
import FirebaseAuth
import Observation

@Observable
class AuthManager {
    var currentUser: FirebaseAuth.User?
    var isLoggedIn = false
    
    init() {
        // Firebase에서 현재 로그인한 사용자가 있는지 확인
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    // 자동 로그인 여부를 확인하고 로그인 상태 및 사용자 UID를 반환하는 함수
    func checkAutoLogin() -> (isLoggedIn: Bool, userUid: String?) {
        if let user = Auth.auth().currentUser {
            currentUser = user
            isLoggedIn = true
            return (true, user.uid) // 로그인된 상태와 사용자 UID 반환
        } else {
            isLoggedIn = false
            return (false, nil) // 로그인되지 않은 상태
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
