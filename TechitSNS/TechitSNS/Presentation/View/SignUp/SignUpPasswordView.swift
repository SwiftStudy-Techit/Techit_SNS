//
//  SignUpPasswordView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpPasswordView: View {
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    Text("다른 사람이 추측할 수 없는 문자 또는 숫자로 5자리 이상 비밀번호를 만드세요.")
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    
                    SecureField("비밀번호를 입력해 주세요.", text: $password)
                        .loginSecureFieldStyle(width: geometry.size.width * 0.9, height: 50)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpNameView()) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: password.isEmpty)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("비밀번호 만들기")
            }
        }
    }
}

#Preview {
    SignUpPasswordView()
}
