//
//  TechitSNSApp.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import SwiftUI
import Firebase

@main
struct TechitSNSApp: App {
//    init() {
//        FirebaseApp.configure()
//    }
    //delegate를 아래 파일로 선언한 AppDelegate로 쓰겠다
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView(loginViewModel: .init())
        }
    }
}
