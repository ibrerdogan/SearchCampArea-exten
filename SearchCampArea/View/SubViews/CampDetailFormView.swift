//
//  CampDetailFormView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 1.07.2022.
//

import SwiftUI
import URLImage
struct CampDetailFormView: View {
    var campArea : CampingArea
    @State var temperature : Double = 0
    @State var hummudity : Int = 0
    @State var status = ""
    @State var statusCode = 0
    @ObservedObject var manager : CampingAreaManager
    @ObservedObject var userManager : UserManager
    @Environment(\.presentationMode) var presentationMode
    @State var showComments = false
    var body: some View {
        VStack {
            //tab view for pictures
            VStack {
                TabView{
                    if campArea.picLink != "" {
                        URLImage(URL(string: campArea.picLink)!,
                                 empty: {
                                Image("Image-1").resizable()
                                .frame(width: 150, height: 100, alignment: .center)
                                
                                 },
                                 inProgress: { progress in
                                    ProgressView().progressViewStyle(.automatic)
                                 },
                                 failure: { error, retry in
                                    Image("Image-1").resizable()
                                    .frame(width: 150, height: 100, alignment: .center)
                                 },
                                 content: { image, info in
                                    image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                 })
                        .tabItem {
                            Text("")
                    }
                    } else {
                        Image("Image-1").resizable()
                        //.frame(width: 150, height: 100, alignment: .center)
                        .tabItem {
                            Text("")
                        }
                    }
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            
            
            Form{
                HStack{
                    Spacer()
                    Text(campArea.name).bold()
                    Spacer()
                }
                .padding()
                .background(Color(.init(gray: 0.3, alpha: 0.2)))
                Section {
                    HStack{
                        Text(campArea.city).bold()
                       
                    }
                } header: {
                    Text("City")
                }
                Section {
                    HStack{
                        VStack(spacing:10){
                            Text("\(campArea.lat)")
                            Text("\(campArea.lon)")
                        }
                        Spacer()
                        Button {
                            OpenWithMaps(latitude: campArea.lat, longitude: campArea.lon)
                        } label: {
                            Text("Open With Google Maps")
                                .padding()
                        }

                    }
                } header: {
                    Text("Location")
                }
                
                Section {
                    HStack{
                        VStack(alignment:.leading, spacing:10){
                            Text("Current Temperature \(String(format: "%.1f", temperature/10) )°C ")
                            Text("Current Hummudity %\(hummudity)")
                            Text("Current Weather is  \(status)")
                           
                           
                           
                        }
                        .padding()
                        Spacer()
                        VStack{
                            switch statusCode
                            {
                            case 0:
                                EmptyView()
                            case 200...232:
                                Image(systemName: "tornado")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            case 300...321:
                                Image(systemName: "cloud.drizzle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            case 500...531:
                                Image(systemName: "cloud.rain.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            case 600...622:
                                Image(systemName: "snowflake.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            case 700...781:
                                Image(systemName: "sun.dust")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            case 800...804:
                                Image(systemName: "sun.max.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            default:
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            }
                        }
                        .padding()
                       

                    }
                } header: {
                    Text("Current Weather")
                }
                
                Section {
                    HStack{
                        Text("Wc and Shower")
                        Image(systemName: campArea.wc ? "checkmark.square" : "square")
                    }.padding()
                    HStack{
                        Text("Internet")
                        Image(systemName: campArea.internet ? "checkmark.square" : "square")
                    }.padding()
                    HStack{
                        Text("Market or Shop")
                        Image(systemName: campArea.water ? "checkmark.square" : "square")
                    }.padding()
                    HStack{
                        Text("Restaurant")
                        Image(systemName: campArea.restaurant ? "checkmark.square" : "square")
                    }.padding()
                } header: {
                    Text("Camping Facilities")
                }
                Section {
                    HStack{
                        VStack(alignment:.leading, spacing:10){
                            Text(campArea.info)
                                .frame(width: .infinity, height: 200, alignment: .topLeading)
                                .lineLimit(5)
                            
                        }
                    }
                } header: {
                    Text("Camping Additional Information")
                } footer: {
                    Text("Added By \(campArea.createdUser)")
                }
                Button {
                    showComments.toggle()
                } label: {
                    Text("Show Comments").bold()
                }
               


            }
            if manager.selectedArea.createdUser == userManager.CampUser.email
            {
                HStack {
                    Spacer()
                    Button(role: .destructive) {
                        manager.deleteCampArea(id: manager.selectedArea.id)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Delete").bold()
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.init(gray: 0.3, alpha: 0.2)))
            }
            else
            {
                EmptyView()
            }
            HStack {
                Spacer()
                Button(role: .destructive) {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                        .bold()
                }
                Spacer()
               

            }.padding()
                .background(Color(.init(white: 0.3, alpha: 0.2)))

        }
        .onAppear(){
            manager.GetAreaComments(id: campArea.id)
            manager.getAreaWeather(longitute: manager.selectedArea.lon, latitute: manager.selectedArea.lat) { model in
                temperature = model.main.feels_like  ?? 0
                hummudity = model.main.humidity ?? 0
                status = model.weather[0].main ?? ""
                statusCode = model.weather[0].id ?? 0
                
            
                
            }
        }
        .popover(isPresented: $showComments) {
            CommentScreen(campingManager: manager , user:userManager.CampUser)
        }
    }
}

struct CampDetailFormView_Previews: PreviewProvider {
    static var previews: some View {
        CampDetailFormView(campArea: CampingArea(id: "", name: "bak",lat: 0.0 ,lon: 0.0, city: "", adress: "",telephone: "0"),manager: CampingAreaManager(),userManager: UserManager())
    }
}

struct ImageModifier : ViewModifier
{
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100, alignment: .center)
       }
    
    
}
