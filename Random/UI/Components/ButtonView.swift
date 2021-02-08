//
//  ButtonView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    
    let background: UIColor
    let textColor: UIColor
    let borderColor: UIColor
    let text: String
    let switchImage: Bool
    let image: String
    
    var body: some View {
        ZStack {
            backgroundColor
            
            HStack {
                imageView
                textView
            }
        }
    }
}


// MARK: UI
private extension ButtonView {
    private var backgroundColor: AnyView {
        AnyView(
            Color(background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(borderColor), lineWidth: 1.5))
                
                .frame(height: 52)
        )
    }
}

private extension ButtonView {
    private var imageView: AnyView {
        AnyView(
            VStack(spacing: 0) {
                if switchImage {
                    Image(image)
                        .renderingMode(.template)
                        .foregroundColor(Color(textColor))
                }
            }
        )
    }
}

private extension ButtonView {
    private var textView: AnyView {
        AnyView(
            Text(text)
                .foregroundColor(Color(textColor))
                .font(.robotoMedium18())
        )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(background: .primaryPale(),
                   textColor: .black,
                   borderColor: .red,
                   text: "Продолжить с Apple",
                   switchImage: true,
                   image: "datePicerRubls")
    }
}

