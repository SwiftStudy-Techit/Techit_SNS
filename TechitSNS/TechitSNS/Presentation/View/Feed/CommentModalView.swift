//
//  CommentModalView.swift
//  TechitSNS
//
//  Created by 김동경 on 10/6/24.
//

import SwiftUI

struct CommentModalView: View {
    
    @ObservedObject var viewModel: FeedViewModel
    
    @State private var text: String = ""
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ScrollView {
                    LazyVStack {
                        if !viewModel.comments.isEmpty {
                            ForEach(viewModel.comments, id: \.commentId) { comment in
                                CommentCellItemView(comment: comment, size: proxy.size.width)
                                Divider()
                            }
                        } else {
                            Text("아직 댓글이 없습니다. 댓글을 입력해 보세요.")
                                .padding()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
               
                Divider()
                
                HStack(alignment: .top) {
                    
                    TextField("댓글을 입력해 보세요.", text: $text)
//                    TextEditor(text: $text)
//                        .overlay(alignment: .topLeading) {
//                            if text.isEmpty {
//                                Text("댓글을 입력해 보세요.")
//                                    .offset(x: 5)
//                            }
//                        }
//                        .frame(maxHeight: proxy.size.height * 0.05)
//                        .background(.red)
                    
                    Button {
                        if !text.isEmpty {
                            Task {
                                await viewModel.uploadComment(text)
                                text = ""
                            }
                        }
                    } label: {
                        Text("입력")
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    
                }
               
            }
            .padding()
        }
    }
}

struct CommentCellItemView: View {
    
    let comment: Comment
    let size: CGFloat
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: comment.writerProfileUrl)) { phase in
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(comment.writerName)
                    
                    Text(comment.comment)
                        .font(.body)
                    Text(comment.createAt.formattedTimeAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            
        }
        .padding(.vertical,12)
    }
}

#Preview {
    CommentModalView(viewModel: .init())
}
