//
//  LoginView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct LoginView: View {
    var signUpViewModel = SignUpViewModel()
    @Bindable var loginViewModel: LoginViewModel
    @State private var isShowingAlert = false // 로그인 오류 Alert
    @State private var isShowingSignUpView = false // 회원가입 화면으로 이동하는 상태 변수
    
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
                    TextField("이메일을 입력해 주세요.", text: $loginViewModel.user.userEmail)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50)
                        .keyboardType(.emailAddress)
                    
                    // 비밀번호 입력 텍스트필드
                    SecureField("비밀번호를 입력해 주세요.", text: $loginViewModel.user.password)
                        .loginSecureFieldStyle(width: geometry.size.width * 0.9, height: 50, isError: loginViewModel.errorMessage == "비밀번호 오류")
                    
                    // 비밀번호 오류 시 텍스트 표시
                    if let errorMessage = loginViewModel.errorMessage, errorMessage == "비밀번호 오류" {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding(.bottom, 20)
                            .font(.footnote)
                            .frame(width: geometry.size.width * 0.9, alignment: .leading) // 왼쪽 정렬
                    }
                    
                    // 로그인 확인 버튼
                    Button("확인") {
                        Task {
                            do {
                                // 로그인 시도(결과값 사용 X)
                                _ = try await loginViewModel.login()
                            } catch {
                                // 계정 찾을 수 없을 때 Alert
                                if loginViewModel.errorMessage == "계정을 찾을 수 없음" {
                                    isShowingAlert = true
                                }
                            }
                        }
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text(loginViewModel.errorMessage!),
                              message: Text("\(loginViewModel.user.userEmail)에 연결된 계정을 찾을 수 없습니다. 다른 이메일 주소를 사용해보세요. SNS 계정이 없으면 가입할 수 있습니다."),
                              primaryButton: .default(Text("가입하기"), action: {
                            isShowingSignUpView = true // 상태 변수 변경
                        }),
                              secondaryButton: .cancel(Text("다시 시도"))
                        )
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: loginViewModel.user.userEmail.isEmpty || loginViewModel.user.password.isEmpty)
                    
                    Spacer()
                    
                    // 회원가입 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpEmailView(signUpViewModel: signUpViewModel)) {
                        Text("새 계정 만들기")
                    }
                    .loginButtonStyle(isFilled: false, width: geometry.size.width * 0.9, isDisabled: false)
                    .padding(.bottom, 20)
                }
                // Alert에서 회원가입 버튼 클릭 시 회원가입뷰로 이동
                .navigationDestination(isPresented: $isShowingSignUpView) {
                    SignUpEmailView(signUpViewModel: signUpViewModel)
                }
                
                // 로그인 성공 시 메인탭뷰로 이동
                .navigationDestination(isPresented: $loginViewModel.isLoggedIn) {
                    MainTabView()
                        .navigationBarBackButtonHidden(true)
                }
                .applyGradientBackground()
            }
        }
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
}
