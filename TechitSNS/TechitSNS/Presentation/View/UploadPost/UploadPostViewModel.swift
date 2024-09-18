//
//  UploadPostViewModel.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/11.
//

import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SwiftUI


class UploadPostViewModel: ObservableObject {
    
   

    @Published var images: [UIImage] = []     //이미지 배열
    @Published var selectedPhotos: [PhotosPickerItem] = [] //선택된 포토아이템 배열
    @Published var text: String = "" //본문
    @Published var isLoading: Bool = false //로딩 프로그래스 바
    @Published var isFinish: Bool = false
    var post = Post(text: "")
    
    //글 업로드 버튼 눌렸을 때 호출되는 함수
    func uploadPost() {
        self.isLoading = true
        Task {
            post.text = self.text
            let imageDatas = convertImageToData()
            //Post데이터의 imagesUrl데이터에 사진 주소값들이 들어간 배열 넣어줌
            post.imagesUrl = try await uploadImages(imageDatas, postId: post.postId)
            try await uploadPostData(post)
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.isFinish = true
            }
            
        }
    }
    
    //UIImage 배열을 Storage에 업로드 하기 위해 UIImage를 -> Data로 변환하여 반환하는 함수
    func convertImageToData() -> [Data] {
        return self.images.compactMap { uiImage in
            uiImage.jpegData(compressionQuality: 0.5)
        }
    }
    
    
    //Storage에 이미지를 업로드 하고 이미지 주소를 반환하는 함수
    func uploadImages(_ images: [Data], postId: String) async throws -> [String] {
        var imageUrls: [String] = []
        let StorageRef = Storage.storage().reference()
        do {
            for image in images {
                let ref = StorageRef.child("Post").child(postId).child(UUID().uuidString)
                let _ = try await ref.putDataAsync(image)
                let url = try await ref.downloadURL()
                imageUrls.append(url.absoluteString)
                print("\(url.absoluteString)")
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        return imageUrls
    }
    
    
    //파이어스토어에 포스트 데이터 업로드 하는 함수
    func uploadPostData(_ post: Post) async throws {
        let db = Firestore.firestore()
        do {
            let postEncode = try Firestore.Encoder().encode(post)
            try await db.collection("Post").document(post.postId).setData(postEncode)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    
    //PhotosPickerItem을 UIImage로 변환하여 images 배열에 값을 추가하는 함수
    @MainActor
    func convertPickerItemToImage() {
        images.removeAll()

        if !selectedPhotos.isEmpty {
            for photo in selectedPhotos {
                Task {
                    if let imageData = try await photo.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: imageData) {
                            images.append(image)
                        }
                    }
                }
            }
        }
    }
    
    
    
}


