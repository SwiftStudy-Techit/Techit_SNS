//
//  SignUpCompletedView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpCompletedView: View {
    let name: String // 전달된 이름
    let profileImage: Image // 전달된 프사
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    // SNS 로고
                    Text("SNS")
                        .font(.custom("Copperplate", size: 80))
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.5,
                               height: geometry.size.width * 0.5)
                        .clipShape(Circle())
                    
                    Text("\(name) 님,\nSNS에 오신 것을 환영합니다!")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    // 회원가입 완료 버튼
                    NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)) {
                        Text("완료")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: false)
                }
                .applyGradientBackground()
            }
        }
    }
}

#Preview {
    SignUpCompletedView(name: "sample", profileImage: Image(.profile))
}
