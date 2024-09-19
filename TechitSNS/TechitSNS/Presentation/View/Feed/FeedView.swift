//
//  FeedView.swift
//  TechitSNS
//
//  Created by 김동경 on 9/18/24.
//

import SwiftUI

enum SwipeDirection {
    case up
    case down
    case none
}

struct FeedView: View {
    
    @EnvironmentObject private var viewModel: FeedViewModel
    @State private var headerHeight: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var lastHeaderOffset: CGFloat = 0
    @State private var direction: SwipeDirection = .none
    @State private var shiftOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.feeds, id: \.postId) { feed in
                        FeedItemView(feed: feed, size: geometry.size.width)
                    }
                }
                .padding(.top, headerHeight)
                .offsetY { previous, current in
                    if previous > current {
                        print("up", current)
                        if direction != .up && current < 0 {
                            shiftOffset = current - headerOffset
                            direction = .up
                            lastHeaderOffset = headerOffset
                        }
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                    } else {
                        print("down", current)
                        if direction != .down {
                            shiftOffset = current
                            direction = .down
                            lastHeaderOffset = headerOffset
                        }
                        let offset = lastHeaderOffset + (current - shiftOffset)
                        headerOffset = (offset > 0 ? 0 : offset)
                    }
                }
            }
            .refreshable {
                await viewModel.loadFeed()
            }
            .task {
                await viewModel.loadFeed()
            }
            .coordinateSpace(name: "SCROLL")
            .overlay(alignment: .top) {
                HeaderView()
                    .anchorPreference(key: HeaderBoundsKey.self, value: .bounds) { $0 }
                    .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                        GeometryReader { geometry in
                            if let anchor = value {
                                Color.clear
                                    .onAppear {
                                        headerHeight = geometry[anchor].height
                                    }
                            }
                        }
                    }
                    .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                HStack {
                    Text("SNS")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "message.fill")
                    }
                }
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.horizontal, -15)
            }
            .padding([.horizontal, .top], 15)
        }
        .padding(.top, safeArea().top)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .padding(.bottom, 20)
    }
    
}


struct FeedItemView: View {
    
    let feed: Post
    let size: CGFloat
    
    var body: some View {
        VStack {
            //작성자 정보 섹션
            HStack {
                
                AsyncImage(url: URL(string: feed.writerProfileUrl)) { image in
                    image
                        .resizable()
                        .frame(width: size / 9, height: size / 9)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                
                Text(feed.writerName)
                    .foregroundStyle(.primary)
                    .bold()
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 3)
            
            //사진 섹션
            TabView {
                ForEach(feed.imagesUrl, id:\.self) { url in
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .frame(height: 300)
            .frame(maxWidth: size, maxHeight: size) // 최대 높이를 설정
            .tabViewStyle(.page)
            
            
            //본문 섹션
            HStack {
                Text(feed.text)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
            
            //시간섹션
            HStack {
                Text(feed.date.formattedTimeAgo)
                    .foregroundStyle(.gray)
                    .font(.caption)
                Spacer()
            }
            .padding(.horizontal)
            
        }
    }
    
}

#Preview {
    FeedView()
        .environmentObject(FeedViewModel())
}
