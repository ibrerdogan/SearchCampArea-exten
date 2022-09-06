//
//  CheckBoxView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 22.06.2022.
//

import SwiftUI

struct CheckBoxView: View {
    @State var check : Bool
    @State var text : String
    let callback: (Bool)->()
    
    init(callback: @escaping (Bool)->(),check : Bool,text : String)
    {
        self.callback = callback
        self.check = check
        self.text = text
    }
    
    var body: some View {
        Button {
            check.toggle()
            self.callback(self.check)
        } label: {
            HStack(spacing : 5)
            {
                Image(systemName: check ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(check ? .blue : .black )
                Text(text)
                    .foregroundColor(check ? .blue : .black )
            }
        }

    }
}

