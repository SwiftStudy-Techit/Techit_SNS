//
//  View+Extension.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

// 배경에 그라데이션 스타일을 추가하는 Extension
extension View {
    func applyGradientBackground() -> some View {
        ZStack {
            LinearGradient(stops: [
                Gradient.Stop(color: .gradientBeige, location: 0.1),
                Gradient.Stop(color: .gradientPink, location: 0.3),
                Gradient.Stop(color: .gradientBlue, location: 0.6),
                Gradient.Stop(color: .gradientGreen, location: 1)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            self
        }
    }
}

// 로그인 버튼 스타일
extension View { // if문 조건을 Bool로 빼서 처리
    func loginButtonStyle(isFilled: Bool, width: CGFloat) -> some View {
        self
            .frame(width: width)
            .padding(.vertical, 15) // 위아래 패딩
            .background(isFilled ? .blue : .white)
            .foregroundStyle(isFilled ? .white : .blue)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blue, lineWidth: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
