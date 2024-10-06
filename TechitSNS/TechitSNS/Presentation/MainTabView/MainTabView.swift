//
//  MainTabView.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/09.
//

import SwiftUI

struct MainTabView: View {
    
    //메인 탭뷰 상태를 위한 변수 선언
    @State private var mainTabType: MainTabType = .home
    @State private var isWritePostView: Bool = false
    
    @StateObject private var postViewModel: FeedViewModel = .init()
    var body: some View {
        //탭뷰
        TabView(selection: $mainTabType) {
            FeedView()
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        //탭뷰가 클릭되었을 때 이미지를 다르게하기 위한 삼항연산자
                        Image(systemName: mainTabType == .home ? "house.fill" : "house")
                    }
                }
                .environmentObject(postViewModel)
                .tag(MainTabType.home)
            
            
            Text("Post")
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        //탭뷰가 클릭되었을 때 이미지를 다르게하기 위한 삼항연산자\
                        Image(systemName: mainTabType == .post ? "plus.square" : "plus.square.fill")
                    }
                }
                .onChange(of: mainTabType) { _, newValue in
                    if newValue == .post {
                        isWritePostView.toggle()
                        mainTabType = .home
                    }
                }
                .tag(MainTabType.post)
            
            ProfileView()
                .tabItem {
                    Label {
                        Text("Profile")
                    } icon: {
                        //탭뷰가 클릭되었을 때 이미지를 다르게하기 위한 삼항연산자
                        Image(systemName: mainTabType == .profile ? "person.circle" : "person.circle.fill")
                    }
                }
                .tag(MainTabType.profile)
            
        }
        .fullScreenCover(isPresented: $isWritePostView) {
            UploadPostView() {
                isWritePostView.toggle()
                postViewModel.refreshFeed()
            }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
