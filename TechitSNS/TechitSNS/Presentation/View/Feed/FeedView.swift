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
    
    @State private var isCommentSheet: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.feeds, id: \.postId) { feed in
                        FeedItemView(feed: feed, size: geometry.size.width) {
                            viewModel.selectedPost = feed
                            isCommentSheet.toggle()
                        }
                        .onAppear {
                            // 마지막 아이템에 도달했을 때 추가 로드
                            if feed.postId == viewModel.feeds.last?.postId {
                                Task {
                                    await viewModel.loadFeed()
                                }
                            }
                        }
                    }
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    // 모든 데이터 로드 완료 시 표시 (옵션)
                    if viewModel.isEndReached {
                        Text("모든 피드를 불러왔습니다.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top, headerHeight)
                .offsetY { previous, current in
                    if previous > current {
                        if direction != .up && current < 0 {
                            shiftOffset = current - headerOffset
                            direction = .up
                            lastHeaderOffset = headerOffset
                        }
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                    } else {
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
                viewModel.refreshFeed()
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
            .sheet(isPresented: $isCommentSheet) {
                CommentModalView(viewModel: viewModel)
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
    let commentAction: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            
            HStack {
                
                AsyncImage(url: URL(string: feed.writerProfileUrl)) { phase in
                    switch phase {
                    case .success(let image): //이미지 로드에 성공함
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size / 9, height: size / 9)
                            .clipShape(Circle())
                    case .failure: //이미지 로드실패
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size / 9, height: size / 9)
                            .clipShape(Circle())
                    case .empty: //?? 비어있음?
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size / 9, height: size / 9)
                            .clipShape(Circle())
                    @unknown default: //?디폴트?
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: size / 9, height: size / 9)
                            .clipShape(Circle())
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(feed.writerName)
                        .foregroundStyle(.primary)
                        .bold()
                    Text(feed.date.formattedTimeAgo)
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                }
            } //사용자 정보 섹션
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
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            
            
            //댓글
            HStack {
                Button {
                    commentAction()
                } label: {
                    HStack {
                        Image(systemName: "bubble.left.fill")
                            .tint(.primary)
                        Text("\(feed.commentCount)")
                    }
                    
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            
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
