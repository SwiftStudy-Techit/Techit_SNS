//
//  SignUpCompletedView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpCompletedView: View {
    var signUpViewModel: SignUpViewModel
    @State private var isSignUpCompleted = false // 회원가입 완료 상태를 관리
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    // SNS 로고
                    Text("SNS")
                        .font(.custom("Futura", size: 80))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    Image(.profile)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.5,
                               height: geometry.size.width * 0.5)
                        .clipShape(Circle())
                    
                    Text("\(signUpViewModel.user.userName) 님,\nSNS에 오신 것을 환영합니다!")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    // 회원가입 완료 버튼
                    Button("완료") {
                        Task {
                            do {
                                // signUp 호출(결과값 사용 X)
                                _ = try await signUpViewModel.signUp()
                                isSignUpCompleted = true
                            } catch {
                                print("회원가입 중 에러 발생: \(error)")
                            }
                        }
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: false)
                }
                .navigationDestination(isPresented: $isSignUpCompleted) {
                    MainTabView()
                        .navigationBarBackButtonHidden(true)
                }
                .navigationBarBackButtonHidden(true)
                .applyGradientBackground()
            }
        }
    }
}

#Preview {
    SignUpCompletedView(signUpViewModel: SignUpViewModel())
}
