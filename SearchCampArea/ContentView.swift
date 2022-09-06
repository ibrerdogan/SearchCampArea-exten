//
//  ContentView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.05.2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var tabIndex = 0
    @ObservedObject var manager : UserManager
    @ObservedObject var campingAreaManager : CampingAreaManager
    var body: some View {
        VStack {
            TabView(selection: $tabIndex) {
              
                MainView(userManager: manager, campingAreaManager: campingAreaManager)
                    .tabItem {
                        Image(systemName: "house.fill")
                    }
                    .tag(0)
                
                SearchMap(userManager: manager)
                    .tabItem {
                        Image(systemName: "network")
                    }
                    .tag(1)
                ProfileView(creationOrUpdate: true,userManager: manager,campingAreaManager: campingAreaManager)
                     .tabItem {
                         Image(systemName: "person.fill")
                     }.tag(2)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(manager: UserManager(),campingAreaManager: CampingAreaManager())
    }
}
