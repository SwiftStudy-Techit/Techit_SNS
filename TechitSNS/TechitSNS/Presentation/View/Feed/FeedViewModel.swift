//
//  FeedViewModel.swift
//  TechitSNS
//
//  Created by 김동경 on 9/18/24.
//
import FirebaseAuth
import FirebaseFirestore
import Foundation

class FeedViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    
    @Published var feeds: [Post] = []
    @Published var isLoading: Bool = false
    @Published var comments: [Comment] = []
    
    @Published var selectedPost: Post? {
        didSet {
            Task {
                await loadComment()
            }
        }
    }
    
    private var commentsCache: [String: [Comment]] = [:] //댓글 캐쉬
    private var lastDocument: DocumentSnapshot?          //페이징을 위한 마지막 문서
    private let pageSize: Int = 10                       //데이터 10개씩 가져올거임
    var isEndReached: Bool = false               //더 이상 가져올 데이터 없음 판별
    
    
    
    //Feed데이터를 로드하는 함수
    func loadFeed() async {
        print("loadFeed")
        guard !isEndReached else {
            return
        }
        
        //데이터 가져오는 중
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        var query: Query = db.collection("Post").order(by: "date", descending: true).limit(to: pageSize) //쿼리 설정
        
        if let lastDoc = lastDocument { //만약 마지막 문서가 존재한다면 쿼리에 속성 추가
            query = query.start(afterDocument: lastDoc) //현재 내가 가져온 마지막 문서로부터 다음 데이터를 가져오게
        }
        
        do {
            //날짜 순으로 피드 데이터를 가져오는 로직
            let documents = try await db.collection("Post").order(by: "date", descending: true).getDocuments().documents
            
            
            
            let post = try documents.compactMap { snapshot in
                try snapshot.data(as: Post.self)
            }
            
            DispatchQueue.main.async {
                if documents.count + 1 < self.pageSize {
                    self.isEndReached = true
                }
                self.lastDocument = documents.last
                self.feeds = post
                self.isLoading = false
            }
        } catch {
            print("\(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func refreshFeed() {
        guard !isLoading else { return }
        isLoading = true
        isEndReached = false
        lastDocument = nil
        feeds.removeAll()
        
        db.collection("Post").order(by: "date", descending: true).limit(to: pageSize).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            do { self.isLoading = false }
            
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            let newPosts = snapshot.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            
            DispatchQueue.main.async {
                self.feeds = newPosts
                self.lastDocument = snapshot.documents.last
            }
        }
    }

    
    //댓글을 가져오는 함수
    func loadComment() async {
        //선택된 포스트
        guard let post = selectedPost else {
            self.comments = []
            return
        }
        //댓글 캐쉬에 이미 저장되어 있다면 서버에서 가져오지 않고 캐쉬에서 가져오게
        if let cachedComments = commentsCache[post.postId] {
            self.comments = cachedComments
            return
        }
        
        do {
            //댓글을 가져오는 로직
            let comments = try await db.collection("Post").document(post.postId).collection("Comment")
                .order(by: "createAt", descending: true).getDocuments().documents
                .compactMap { snapshot in
                    try snapshot.data(as: Comment.self)
                }
            DispatchQueue.main.async {
                //가져온 댓글을 데이터에 추가
                self.commentsCache[post.postId] = comments
                self.comments = comments
            }
        } catch {
            //토스트나 스낵바 메시지로 에러표시
            print("댓글을 가져오는데 실패")
        }
    }
    
    
    //댓글을 업로드하는 함수
    func uploadComment(_ text: String) async {
        
        //선택된 포스트
        guard let post = selectedPost else {
            self.comments = []
            return
        }
        //유저 uid 가져와야 함
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        do {
            
            let userData = try await getUserData(userUid) //유저 정보 가져오기
            let comment = createComment(text: text, userUid: userUid, userData: userData) //댓글 생성
            
            //comment데이터 인코딩해서 데이터 업로드
            let commentEncode = try Firestore.Encoder().encode(comment)
            try await db.collection("Post").document(post.postId).collection("Comment").document(comment.commentId).setData(commentEncode)
            
            //Post컬렉션의 문서 데이터엥 댓글 카운트 수 1개 증가 시키기
            try await db.collection("Post").document(post.postId).updateData([
                "commentCount": FieldValue.increment(Int64(1))
            ])
            
            DispatchQueue.main.async {
                self.comments.append(comment) //댓글 데이터에 댓글 추가(다시 서버에서 load해도 되지만 서버와 통신 성공했다면 로컬에서 처리하는 방식 사용)
                if let index = self.feeds.firstIndex(where: { $0.postId == post.postId }) { //위와 마찬가지 댓글 데이터 로컬에서 댓글 카운트 수 처리
                    var post = self.feeds[index]
                    post.commentCount += 1
                    DispatchQueue.main.async {
                        self.feeds[index] = post
                    }
                }
            }
        } catch {
            //토스트로 에러 메시지 표현하면 될 듯
            print("댓글 업로드 실패함")
        }
    }
    
    
    
    
    //유저 정보를 가져오는 함수
    func getUserData(_ userUid: String) async throws -> UserDTO2 {
        do {
            return try await db.collection("Users").document(userUid).getDocument(as: UserDTO2.self)
        } catch {
            throw error
        }
    }
    
    // 댓글 데이터 생성 함수
    private func createComment(text: String, userUid: String, userData: UserDTO2) -> Comment {
        let comment = Comment(
            writerUid: userUid,
            writerName: userData.userName,
            writerProfileUrl: userData.profileUrl,
            comment: text
        )
        return comment
    }
    
}

