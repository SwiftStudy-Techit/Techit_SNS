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
import FirebaseAuth


enum UploadError: Error {
    case upLoadImageFailed
    case loadFailedUserInfo
    case upLoadPostFailed
}

enum LoadState {
    case none
    case loading
    case finish
}

class UploadPostViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var images: [UIImage] = []     //이미지 배열
    @Published var selectedPhotos: [PhotosPickerItem] = [] //선택된 포토아이템 배열
    @Published var text: String = "" //본문
    @Published var isLoadState: LoadState = .none
    var post = Post(text: "")
    
    //글 업로드 버튼 눌렸을 때 호출되는 함수
    func uploadPost() async {
        
        guard let userUid = Auth.auth().currentUser?.uid else {
            print("로그인 상태가 아님")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoadState = .loading
        }
        
        do {
            post.text = self.text
            let imageDatas = convertImageToData()
            post.imagesUrl = try await uploadImages(imageDatas, postId: post.postId)
            let writerInfo = try await getUserData(userUid)
            post.writerName = writerInfo.userName
            post.writerProfileUrl = writerInfo.profileUrl
            post.writerUid = userUid
            try await uploadPostData(post)
            
            DispatchQueue.main.async {
                self.isLoadState = .finish
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //UIImage 배열을 Storage에 업로드 하기 위해 UIImage를 -> Data로 변환하여 반환하는 함수
    func convertImageToData() -> [Data] {
        return self.images.compactMap { uiImage in
            uiImage.jpegData(compressionQuality: 0.3)
        }
    }
    
    func getUserData(_ userUid: String) async throws -> UserDTO2 {
        do {
            return try await db.collection("Users").document(userUid).getDocument(as: UserDTO2.self)
        } catch {
            throw error
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
            }
            return imageUrls
        } catch {
            throw UploadError.upLoadImageFailed
        }
    }
    
    
    //파이어스토어에 포스트 데이터 업로드 하는 함수
    func uploadPostData(_ post: Post) async throws {
        do {
            let postEncode = try Firestore.Encoder().encode(post)
            try await db.collection("Post").document(post.postId).setData(postEncode)
        } catch {
            throw UploadError.upLoadPostFailed
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


