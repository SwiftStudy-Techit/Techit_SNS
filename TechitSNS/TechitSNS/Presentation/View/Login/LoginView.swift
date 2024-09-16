//
//  LoginView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 15) {
                    Spacer()
                    
                    // SNS 로고
                    Text("SNS")
                        .font(.custom("Copperplate", size: 80))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 이메일 입력 텍스트필드
                    TextField("이메일을 입력해 주세요.", text: $email)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50)
                        .keyboardType(.emailAddress)
                    
                    // 비밀번호 입력 텍스트필드
                    SecureField("비밀번호를 입력해 주세요.", text: $password)
                        .loginSecureFieldStyle(width: geometry.size.width * 0.9, height: 50)
                        .padding(.bottom, 20)
                    
                    // 로그인 확인 버튼(로그인 성공 시 메인탭뷰로 이동)
                    NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)) {
                        Text("확인")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: email.isEmpty || password.isEmpty)
                    
                    Spacer()
                    
                    // 회원가입 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpEmailView()) {
                        Text("새 계정 만들기")
                    }
                    .loginButtonStyle(isFilled: false, width: geometry.size.width * 0.9, isDisabled: false)
                }
                .applyGradientBackground()
            }
        }
    }
}

#Preview {
    LoginView()
}
