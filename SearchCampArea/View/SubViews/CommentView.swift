//
//  CommentView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.06.2022.
//

import SwiftUI

struct CommentView: View {
    var comment : String
    var date : String
    var user : String
    var body: some View {
        
        Rectangle()
            .fill(.white)
            .cornerRadius(30)
            .frame(width: .infinity, height: 150, alignment: .topLeading)
            .padding()
            .shadow(radius: 20)
            .overlay {
                VStack(alignment:.center){
                    HStack(alignment:.firstTextBaseline){
                        Text(comment)
                            .frame(height: 80, alignment: .leading)
                            .lineLimit(5)
                            .padding()
                    }
                    HStack(alignment:.lastTextBaseline){
                        Text(user)
                            .padding(.leading)
                        Spacer()
                        Text("\(date)")
                            .padding(.trailing)
                    }.padding()




                }
            }
        
        
//        Rectangle()
//            .fill(Color(hex: "90C8AC"))
//            .border(.gray, width: 2)
//            .frame(height : 140)
//            .padding()
//            .shadow(color: .black, radius: 2.0, x: 1.0, y: 2)
//            .overlay {
//                VStack(alignment:.center){
//                    HStack(alignment:.firstTextBaseline){
//                        Text(comment)
//                            .frame(height: 80, alignment: .leading)
//                            .lineLimit(5)
//                            .padding()
//                    }
//                    HStack(alignment:.lastTextBaseline){
//                        Text(user)
//                            .padding(.leading)
//                        Spacer()
//                        Text("\(date)")
//                            .padding(.trailing)
//                    }.padding()
//
//
//
//
//                }
//            }
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

