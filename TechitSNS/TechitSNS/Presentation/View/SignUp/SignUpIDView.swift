//
//  SignUpIDView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpIDView: View {
    @Bindable var signUpViewModel: SignUpViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    Text("새 계정에 사용할 ID를 입력하세요. 나중에 언제든지 변경할 수 있습니다.")
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    
                    TextField("ID를 입력해 주세요.", text: $signUpViewModel.user.userId)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpPasswordView(signUpViewModel: signUpViewModel)) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: signUpViewModel.user.userId.isEmpty)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("ID 만들기")
                .customBackButton()
            }
        }
    }
}

#Preview {
    SignUpIDView(signUpViewModel: SignUpViewModel())
}
