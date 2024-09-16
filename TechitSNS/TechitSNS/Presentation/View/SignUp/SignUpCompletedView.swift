//
//  SignUpCompletedView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpCompletedView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    // SNS 로고
                    Text("SNS")
                        .font(.custom("Copperplate", size: 80))
                        .fontWeight(.bold)
                    
                    Text("ㅇㅇ님 SNS에 오신 것을 환영합니다!")
                    
                    // 로그인 확인 버튼
                    NavigationLink(destination: MainTabView()) {
                        Text("확인")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9)
                }
                .applyGradientBackground()
            }
        }
    }
}

#Preview {
    SignUpCompletedView()
}
