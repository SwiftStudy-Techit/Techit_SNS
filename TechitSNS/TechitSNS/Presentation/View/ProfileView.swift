//
//  ProfileView.swift
//  TechitSNS
//
//  Created by 홍지수 on 9/19/24.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @State private var userID = "AVHUHoqKLGdFyk4r7hDOOWaBpjq2"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let profile = viewModel.userProfile {
                    
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
                            AsyncImage(url: URL(string: post.imageURL)) { image in
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
            .background(Color.white) // 배경 색상
            .onAppear {
                if let currentUser = Auth.auth().currentUser {
                    print("Current user UID: \(currentUser.uid)") // 디버깅용 출력
                    self.userID = currentUser.uid
                } else {
                    print("User not logged in, using default userID")
                }
                
                print("Fetching data for userID: \(userID)") // 디버깅용 출력
                viewModel.fetchUserProfile(userID: userID)
                viewModel.fetchUserPosts(userID: userID)
            }
        }
    }
}

#Preview {
    ProfileView()
}
