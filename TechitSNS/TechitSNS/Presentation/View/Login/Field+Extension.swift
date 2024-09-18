//
//  View+Extension.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI

extension TextField {
    func loginTextFieldStyle(width: CGFloat, height: CGFloat, isError: Bool, showClearButton: Bool = true, text: Binding<String>, removeSpaces: Bool = true) -> some View {
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
            .onAppear {
                if showClearButton {
                    UITextField.appearance().clearButtonMode = .whileEditing // clear 버튼 활성화
                } else {
                    UITextField.appearance().clearButtonMode = .never // clear 버튼 비활성화
                }
            }
            .onChange(of: text.wrappedValue) {
                if removeSpaces {
                    // 공백이 포함되었을 경우 공백을 제거
                    text.wrappedValue = text.wrappedValue.replacingOccurrences(of: " ", with: "")
                }
            }
    }
}

extension SecureField {
    func loginSecureFieldStyle(width: CGFloat, height: CGFloat, isError: Bool, text: Binding<String>) -> some View {
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
            .onChange(of: text.wrappedValue) {
                // 공백이 포함되었을 경우 공백을 제거
                text.wrappedValue = text.wrappedValue.replacingOccurrences(of: " ", with: "")
            }
    }
}
