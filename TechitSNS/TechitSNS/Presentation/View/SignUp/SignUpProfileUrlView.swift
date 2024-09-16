//
//  SignUpProfileUrlView.swift
//  TechitSNS
//
//  Created by 김효정 on 9/16/24.
//

import SwiftUI
import PhotosUI

struct SignUpProfileUrlView: View {
    let name: String // 전달된 이름
    @State private var profileUrl = ""
    
    @State private var selectedImage: PhotosPickerItem? // 선택된 사진
    @State private var profileImage: Image? = Image(.profile) // 기본값이 .profile
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 30) {
                    Text("친구들이 회원님을 알아볼 수 있도록 프로필 사진을 추가하세요. 프로필 사진은 모든 사람에게 공개됩니다.")
                        .padding(.top, 20)
                        .padding(.horizontal, 15)
                    
                    // 프사 추가 버튼
                    PhotosPicker(selection: $selectedImage,
                                 matching: .images) {
                        profileImage? // 선택된 사진이 없으면 기본 사진 / 있으면 그 사진으로 보여주기
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.5,
                                   height: geometry.size.width * 0.5)
                            .clipShape(Circle())
                    }
                                 .onChange(of: selectedImage) { // selectedImage 변경될 때마다 호출
                                     Task { // 이미지를 비동기적으로 불러오기 위해 Task 사용
                                         if let loadedData = try? await selectedImage?.loadTransferable(type: Image.self) { // 선택된 이미지를 Image 타입의 데이터로 불러오기
                                             profileImage = loadedData // 그렇게 불러온 데이터를 프로필 이미지에 저장
                                         } else {
                                             print("Failed")
                                         }
                                     }
                                     
                                 }
                    Spacer()
                    
                    Button("사진 추가") {
                        // 서버에 업로드하는 로직
                        // SignUpCompletedView로 이동
                    }
                    .loginButtonStyle(isFilled: true, width: geometry.size.width * 0.9, isDisabled: false)
                    .padding(.bottom, -15)
                    
                    // 다음 버튼(네비게이션으로 이동)
                    NavigationLink(destination: SignUpCompletedView(name: name, profileImage: profileImage!)) {
                        Text("건너뛰기")
                    }
                    .loginButtonStyle(isFilled: false, width: geometry.size.width * 0.9, isDisabled: false)
                }
                .applyGradientBackground()
                .navigationTitle("프로필 사진 추가")
            }
        }
    }
}

#Preview {
    SignUpProfileUrlView(name: "sample")
}
