//
//  UploadPostView.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/11.
//

import PhotosUI
import SwiftUI

struct UploadPostView: View {
    //뷰모델 인스턴스 생성
    @StateObject private var viewModel: UploadPostViewModel = .init()
    @Environment(\.dismiss) private var dismiss
    var finish: () -> Void
    
    init(_ finish: @escaping () -> Void) {
        self.finish = finish
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let size = geometry.size.width
                VStack {
                    //사진을 올리는 PhotosPicker
                    PhotosPicker(
                        selection: $viewModel.selectedPhotos,
                        maxSelectionCount: 3,
                        selectionBehavior: .ordered,
                        matching: .images) {
                            if !viewModel.images.isEmpty {
                                //선택한 이미지가 있을 때
                                ImagePageView(selectedImages: viewModel.images)
                            } else {
                                //선택한 이미지가 없을 때
                                ZStack {
                                    Rectangle()
                                        .frame(width: size)
                                        .foregroundStyle(.white)
                                    
                                    Image(systemName: "photo.on.rectangle")
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: size / 5, height: size / 5)
                                        .tint(.black)
                                }
                            }
                        }
                        .onChange(of: viewModel.selectedPhotos) { oldValue, newValue in
                            //뷰모델의 selectedPhotos값이 바뀔 때마다 convertDataToImage함수 호출
                            viewModel.convertPickerItemToImage()
                        }
                    
                    //글 본문 입력하는 TextEditor
                    TextEditor(text: $viewModel.text)
                        .overlay(alignment: .topLeading) {
                            Text("본문을 입력해 주세요")
                                .foregroundStyle(viewModel.text.isEmpty ? .gray : .clear)
                                .font(.headline)
                        }
                        .padding()
                    
                    //업로드 버튼
                    BlueButton(disabled: viewModel.isLoadState == .loading) {
                        Task {
                            await viewModel.uploadPost()
                        }
                    } content: {
                        Text("업로드")
                            .padding()
                    }
                    
                    
                    Spacer()
                }
            }
            .onChange(of: viewModel.isLoadState) { _, newValue in
                if newValue == .finish {
                    finish()
                }
            }
            .overlay {
                if viewModel.isLoadState == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray)) // 흰색
                        .scaleEffect(1.5) // 크기 조절
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UploadPostView() {
            
        }
    }
}
