//
//  SearchMap.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.05.2022.
//

import SwiftUI
import MapKit
struct SearchMap: View {
    @ObservedObject var manager = CampingAreaManager()
    @ObservedObject var userManager : UserManager
    @State var showDetail = false
    @State var addnewarea = false
    @State var trackMode = MapUserTrackingMode.follow
   
    
    
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom){
            VStack {
                Map(coordinateRegion: $manager.Region,interactionModes: .all,showsUserLocation: true, userTrackingMode: $trackMode,annotationItems: manager.CampingArray){ area in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: area.lat, longitude: area.lon) ) {
                        Button {
                            manager.selectedArea = area
                            showDetail.toggle()
                        } label: {
                            CampMarker(CampAreaName: area.name)
                        }

                    }
                }.onAppear(){
                    manager.fit()
                    manager.checkManager()
                    
                }
            }
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showDetail) {
                CampDetailFormView(campArea: manager.selectedArea,manager: manager,userManager: userManager)
            }
            .fullScreenCover(isPresented: $addnewarea) {
                AddCampingAreaFormView(manager: manager,userMail: userManager.CampUser.email)
            }
            HStack{

                Spacer()
                Button {
                    addnewarea.toggle()
                } label: {
                    Image(systemName: "plus")
                        .AddCampAreaButton()
                }
            }

        }
        
        
            
    
    }
}

struct SearchMap_Previews: PreviewProvider {
    static var previews: some View {
        SearchMap(userManager: UserManager())
    }
}
