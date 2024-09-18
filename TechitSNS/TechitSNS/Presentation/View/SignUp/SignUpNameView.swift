//
//  SignUpNameView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpNameView: View {
    @Bindable var signUpViewModel: SignUpViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    TextField("이름을 입력해 주세요.", text: $signUpViewModel.user.userName)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50, isError: false, text: $signUpViewModel.user.userName, removeSpaces: false)
                        .padding(.top, 20)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpCompletedView(signUpViewModel: signUpViewModel)) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: signUpViewModel.user.userName.isEmpty)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("이름 입력")
                .customBackButton()
            }
        }
    }
}

#Preview {
    SignUpNameView(signUpViewModel: SignUpViewModel())
}
