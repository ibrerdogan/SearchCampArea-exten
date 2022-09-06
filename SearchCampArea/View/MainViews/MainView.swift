//
//  MainView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 24.06.2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userManager : UserManager
    @ObservedObject var campingAreaManager : CampingAreaManager
    @State var city = ""
    @State var wc = false
    @State var water = false
    @State var restaurant = false
    @State var internet = false
    @State var displaySearchBar = false
    @State var displayCampAreaDetail = false
    let columns = [
        GridItem(),
        GridItem()
    ]
    var body: some View {
        VStack{
            Group{
                VStack
                {
                    Text("Wellcome \(userManager.CampUser.name != "" ? userManager.CampUser.name : userManager.CampUser.email )").font(.title)
                }
                .padding()
            }
            VStack(alignment:.center){
                Text("Last Added Areas").font(.title2)
                HStack{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(campingAreaManager.lastCampAreas){camp in
                                Button {
                                    campingAreaManager.selectedArea = camp
                                    self.displayCampAreaDetail.toggle()
                                } label: {
                                    SmallCampingAreaView(picLink: camp.picLink, name: camp.name, city: camp.city)
                                        .padding()
                                }

                            }

                        }
                        
                    }
                }
            }
            Form{
                Section{
                    Toggle(displaySearchBar ? "Hide Search Menu" : "Show Search Menu", isOn: $displaySearchBar)
                }
               if displaySearchBar
                {
                   Section {
                       TextField("City", text: $city)
                       Toggle("Wc", isOn: $wc)
                       Toggle("Internet", isOn: $internet)
                       Toggle("Water", isOn: $water)
                       Toggle("Restaurant", isOn: $restaurant)
                       
                       Button {
                           campingAreaManager.getAreaWithSearch(city: city, water: water, wc: wc, restaurant: restaurant,searchByField: displaySearchBar)
                       } label: {
                           HStack{
                               Spacer()
                               Image(systemName: "magnifyingglass.circle.fill")
                               Text("Search Area")
                               Spacer()
                           }
                           
                       }
                   } header: {
                       Text("Search By ")
                   }
               }
                else
                {
                    EmptyView()
                }
                Section{
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            
                            if campingAreaManager.searchedAreas.count == 0
                            {
                                HStack {
                                    Spacer()
                                    Text("No Area")
                                    Spacer()
                                }
                            }
                            else
                            {
                                ForEach(campingAreaManager.searchedAreas){ area in
                                    Button {
                                        campingAreaManager.selectedArea = area
                                        self.displayCampAreaDetail.toggle()
                                    } label: {
                                        SmallCampingAreaView(picLink: area.picLink, name: area.name, city: area.city)
                                            .padding()
                                    }

                                }
                            }
                        }
                    }
                }

                
            }
            
        }
        .onAppear(){
            campingAreaManager.getLastTenAreas()
            campingAreaManager.getAreaWithSearch(city: "", water: false, wc: false, restaurant: false,searchByField: displaySearchBar)
        }
        .fullScreenCover(isPresented: $displayCampAreaDetail) {
            CampDetailFormView(campArea: campingAreaManager.selectedArea, manager: campingAreaManager, userManager: userManager)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userManager: UserManager(), campingAreaManager: CampingAreaManager())
    }
}
