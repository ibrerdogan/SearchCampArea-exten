//
//  HorizontalView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 27.06.2022.
//

import SwiftUI

struct HorizontalView: View {
    var body: some View {
        HStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(0...5,id: \.self){i in
                        SmallCampingAreaView(picLink: "", name: "", city: "istanbul")
                    }
                }
                
            }
        }
    }
}

struct HorizontalView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalView()
    }
}
