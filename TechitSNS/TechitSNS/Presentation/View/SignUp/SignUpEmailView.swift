//
//  SignUpEmailView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpEmailView: View {
    @State private var email = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    
                    Text("회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 이메일 주소는 다른 사람에게 공개되지 않습니다.")
                        .padding(.top, 20)
                    
                    TextField("이메일을 입력해 주세요.", text: $email)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpIDView()) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("이메일 주소 입력")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    SignUpEmailView()
}
