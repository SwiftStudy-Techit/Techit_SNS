//
//  FeedViewModel.swift
//  TechitSNS
//
//  Created by 김동경 on 9/18/24.
//

import FirebaseFirestore
import Foundation


class FeedViewModel: ObservableObject {
    @Published var feeds: [Post] = []
    @Published var isLoading: Bool = false
    
   
    
    //Feed데이터를 로드하는 함수
    func loadFeed() async {
        let db = Firestore.firestore()
        do {
            let documents = try await db.collection("Post").order(by: "date", descending: true).getDocuments().documents
            let post = try documents.compactMap { snapshot in
                try snapshot.data(as: Post.self)
            }
            DispatchQueue.main.async {
                self.feeds = post
            }
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
