//
//  View+Extension.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

extension TextField {
    func loginTextFieldStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .font(.custom("", size: 18))
            .padding()
            .textInputAutocapitalization(.never) // 첫글자 자동으로 대문자로 바꾸는 기능 비활성화
            .frame(width: width, height: height)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.windowBackground)
                    .frame(width: width, height: height)
                    .shadow(radius: 1)
            }
    }
}

extension SecureField {
    func loginSecureFieldStyle(width: CGFloat, height: CGFloat, isError: Bool) -> some View {
        self
            .font(.custom("", size: 18))
            .padding()
            .textInputAutocapitalization(.never) // 첫글자 자동으로 대문자로 바꾸는 기능 비활성화
            .frame(width: width, height: height)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.windowBackground)
                    .frame(width: width, height: height)
                    .shadow(radius: 1)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isError ? .red : .clear, lineWidth: 1) // 오류 시 빨간색 테두리
            )
    }
}
