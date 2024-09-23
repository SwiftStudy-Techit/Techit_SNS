//
//  SignUpPasswordView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpPasswordView: View {
    @Bindable var signUpViewModel: SignUpViewModel
    @State private var showPassword = false // 비밀번호 보여주는 상태 변수
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    Text("다른 사람이 추측할 수 없는 문자 또는 숫자로 6자리 이상 비밀번호를 만드세요.")
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    
                    // 비밀번호 입력 텍스트필드
                    ZStack {
                        if showPassword {
                            TextField("비밀번호를 입력해 주세요.", text: $signUpViewModel.user.password)
                                .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50, isError: false, showClearButton: false, text: $signUpViewModel.user.password)
                        } else {
                            SecureField("비밀번호를 입력해 주세요.", text: $signUpViewModel.user.password)
                                .loginSecureFieldStyle(width: geometry.size.width * 0.9, height: 50, isError: false, text: $signUpViewModel.user.password)
                        }
                        
                        HStack {
                            Spacer()
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 30) // 텍스트 필드 내부 여백 조정
                        }
                    }
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpNameView(signUpViewModel: signUpViewModel)) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: signUpViewModel.user.password.isEmpty || signUpViewModel.user.password.count < 6)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("비밀번호 만들기")
                .customBackButton()
            }
        }
    }
}

#Preview {
    SignUpPasswordView(signUpViewModel: SignUpViewModel())
}
