//
//  ImagePageView.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/11.
//

import SwiftUI

struct ImagePageView: View {
    let selectedImages: [UIImage]
    var body: some View {
        TabView {
            ForEach(selectedImages, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    ImagePageView(selectedImages: [])
}
