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
    
    var body: some View {
        //탭뷰
        TabView(selection: $mainTabType) {
            Text("Home")
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        //탭뷰가 클릭되었을 때 이미지를 다르게하기 위한 삼항연산자
                        Image(systemName: mainTabType == .home ? "house.fill" : "house")
                    }
                }
                .tag(MainTabType.home)
            
            
            Text("Upload")
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        //탭뷰가 클릭되었을 때 이미지를 다르게하기 위한 삼항연산자\
                        Image(systemName: mainTabType == .post ? "plus.square" : "plus.square.fill")
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
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
