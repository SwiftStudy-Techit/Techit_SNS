//
//  SignUpEmailView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpEmailView: View {
    @Bindable var signUpViewModel: SignUpViewModel
    @State private var showNextView = false // 네비게이션 트리거 상태
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    
                    Text("회원님에게 연락할 수 있는 이메일 주소를 입력하세요. 이메일 주소는 다른 사람에게 공개되지 않습니다.")
                        .padding(.top, 20)
                    
                    TextField("이메일을 입력해 주세요.", text: $signUpViewModel.user.userEmail)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50, isError: !signUpViewModel.isEmailValid, text: $signUpViewModel.user.userEmail)
                        .keyboardType(.emailAddress)
                    
                    // 이메일 형식 오류 시 텍스트 표시
                    if let errorMessage = signUpViewModel.emailErrorMessage {
                        Text(errorMessage)
                            .padding(.top, -20)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .frame(width: geometry.size.width * 0.85, alignment: .leading) // 왼쪽 정렬
                    }
                                        
                    // 다음 버튼(네비게이션으로 이동)
                    Button("다음") {
                        // 이메일 형식 검증
                        signUpViewModel.validateEmail()
                        
                        // 형식 유효하면 다음 화면
                        if signUpViewModel.isEmailValid {
                            showNextView = true
                        }
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: signUpViewModel.user.userEmail.isEmpty)

                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("이메일 주소 입력")
                .navigationBarTitleDisplayMode(.large)
                .customBackButton()
                // 다음 화면 이동
                .navigationDestination(isPresented: $showNextView) {
                    SignUpIDView(signUpViewModel: signUpViewModel)
                }
            }
        }
    }
}

#Preview {
    SignUpEmailView(signUpViewModel: SignUpViewModel())
}
