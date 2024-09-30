//
//  BlueButton.swift
//  TechitSNS
//
//  Created by 김동경 on 2024/09/11.
//

import SwiftUI

struct BlueButton<Content: View> : View {
    
    var disabled: Bool
    let action: () -> Void
    let label: Content
    
    init(disabled: Bool, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.disabled = disabled
        self.action = action
        self.label = content()
    }
    
    var body: some View {
        Button {
            action()
        } label: {
           label
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(!disabled ? .blue : .gray)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
        }
        .disabled(disabled)
    }
}

