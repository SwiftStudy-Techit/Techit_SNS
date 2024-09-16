//
//  SignUpNameView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

struct SignUpNameView: View {
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    TextField("이름을 입력해 주세요.", text: $name)
                        .loginTextFieldStyle(width: geometry.size.width * 0.9, height: 50)
                        .padding(.top, 20)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpProfileUrlView(name: name)) {
                        Text("다음")
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: name.isEmpty)
                    
                    Spacer()
                }
                .applyGradientBackground()
                .navigationTitle("이름 입력")
            }
        }
    }
}

#Preview {
    SignUpNameView()
}
