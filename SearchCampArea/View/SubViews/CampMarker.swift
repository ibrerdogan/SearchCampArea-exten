//
//  CampMarker.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.05.2022.
//

import SwiftUI

struct CampMarker: View {
    var CampAreaName : String
    var body: some View {
        VStack{
            Text(CampAreaName).font(.body)
            Image("tent").resizable()
                .frame(width: 30, height: 30)
                .padding(5)
                .background() {
                    Circle()
                        .stroke(lineWidth: 2)
                        .fill(.green)
                }
            Image(systemName: "triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.green)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -10)
        }

    }
}

struct CampMarker_Previews: PreviewProvider {
    static var previews: some View {
        CampMarker(CampAreaName: "")
    }
}
