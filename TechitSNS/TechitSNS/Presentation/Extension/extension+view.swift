//
//  extension+view.swift
//  TechitSNS
//
//  Created by 김동경 on 9/19/24.
//

import SwiftUI

extension View {
    
    func offsetY(completion: @escaping (CGFloat, CGFloat) -> Void) -> some View {
        self
            .modifier(OffsetHelper(onChange: completion))
    }
    
    func safeArea() -> UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        guard let safeArea = scene.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
    
}


struct OffsetHelper: ViewModifier {
    
    
    var onChange: (CGFloat, CGFloat) -> Void
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .named("SCROLL")).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self) { value  in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset, currentOffset)
                        }
                }
            }
        
    }
}


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}


struct HeaderBoundsKey: PreferenceKey {
    
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
    
}
