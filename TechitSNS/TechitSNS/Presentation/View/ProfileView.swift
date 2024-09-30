//
//  ProfileView.swift
//  TechitSNS
//
//  Created by 홍지수 on 9/19/24.
//

import SwiftUI
import FirebaseStorage

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    
    var userID: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let profile = viewModel.userProfile {
                    
//                    self.userID = profile.userUid
                    
                    // 사용자 프로필
                    HStack {
                        AsyncImage(url: URL(string: profile.profileUrl)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle().fill(Color.gray).frame(width: 80, height: 80)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(profile.userId)
                                .font(.title)
                                .foregroundColor(.white)
                            Text(profile.statusMessage)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()

                    HStack {
                        Button(action: { /* 프로필 편집 */ }) {
                            Text("프로필 편집")
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(8)
                        }

                        Button(action: { /* 프로필 공유 */ }) {
                            Text("프로필 공유")
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                
                // 게시물 그리드
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach($viewModel.posts, id: \.postId) { $post in
                        VStack {
                            //이미지가 배열이기 때문에 첫장만 프로필 쪽에는 첫장만 보여주면 될 것 같아요.
                            AsyncImage(url: URL(string: post.imagesUrl[0])) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                            } placeholder: {
                                Rectangle().fill(Color.gray).frame(width: 100, height: 100)
                            }
                            
                            Text(post.text)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                .padding()
            }
            .background(Color("BackgroundColor")) // 배경 색상
            .onAppear {
                Task {
                    try await viewModel.fetchUserProfile(userID: userID)
                    try await viewModel.fetchUserPosts(userID: userID)
                }
            }
        }
    }
}
