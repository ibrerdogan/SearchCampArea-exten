//
//  SmallCampingAreaView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 27.06.2022.
//

import SwiftUI
import URLImage

struct SmallCampingAreaView: View {
    var picLink = ""
    var name = ""
    var city = ""
    var body: some View {
        
        VStack{
            if picLink != ""
            {
                URLImage(URL(string: picLink)!,
                         empty: {
                        Image(systemName: "person.fill").font(.system(size: 35))
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                        )
                         },
                         inProgress: { progress in
                            ProgressView().progressViewStyle(.automatic)
                         },
                         failure: { error, retry in
                        Image(systemName: "person.fill").font(.system(size: 35))
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50).stroke(Color(.label),lineWidth: 2)
                        )
                         },
                         content: { image, info in
                            image
                        .resizable()
                            .frame(width: 150, height: 100, alignment: .center)
                            .cornerRadius(20)
                         })
            }
            else
            {
                Image("Image-1").resizable()
                    .frame(width: 150, height: 100, alignment: .center)
                    .cornerRadius(20)
                    
            }
            HStack{
                
                Label {
                    Text(city).font(.footnote)
                } icon: {
                    Image(systemName: "mappin.and.ellipse")
                }
                Spacer()


            }
        }
    }
}


