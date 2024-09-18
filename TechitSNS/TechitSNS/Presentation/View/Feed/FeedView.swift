//
//  FeedView.swift
//  TechitSNS
//
//  Created by 김동경 on 9/18/24.
//

import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject private var viewModel: FeedViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.feeds, id: \.postId) { feed in
                        FeedItemView(feed: feed, size: geometry.size.width)
                    }
                }
            }
            .refreshable {
                await viewModel.loadFeed()
            }
            .task {
                await viewModel.loadFeed()
            }
        }
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
