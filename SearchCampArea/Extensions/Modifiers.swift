//
//  Modifiers.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 6.09.2022.
//

import Foundation
import SwiftUI





struct BoardingTextFieldsModifier : ViewModifier{
    var opacity : CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .textFieldStyle(.roundedBorder)
            .opacity(opacity)
            .disableAutocorrection(false)
    }
}


struct AddCampAreaButtonModifier : ViewModifier
{
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .font(.largeTitle)
            .frame(width: 50, height: 50, alignment: .center)
            .padding()
            .overlay(content: {
                Circle()
                    .opacity(0.5)
            })
            .padding()
    }
}

struct URLImageModifier : ViewModifier
{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35))
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
            )
    }
}

struct ProfileImageModifier : ViewModifier
{
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            
    }
}
