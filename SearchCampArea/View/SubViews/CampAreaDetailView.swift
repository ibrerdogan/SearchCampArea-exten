//
//  CampAreaDetailView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 24.05.2022.
//

import SwiftUI
import MapKit
import URLImage
struct CampAreaDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var campArea : CampingArea
    @ObservedObject var manager : CampingAreaManager
    @ObservedObject var userManager : UserManager
    @State var comment : String = ""
    @State var commentsHeight = 0.0
    @State var showComments = false
    @State var city = ""
    @State var temperature : Double = 0
    @State var hummudity : Int = 0
    @State var status = ""
    @State var statusCode = 0
    var body: some View {
        ZStack {
            VStack{
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
                            .frame(width: 150, height: 100, alignment: .center)
                            .tabItem {
                                Text("")
                            }
                        }
                        
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
                .onAppear(){
                    //print("\(campArea.picLink) bu eklenen resim adresi")
                }
                VStack {
                    ScrollView{
                        VStack{
                            HStack{
                                Spacer()
                                Text("Camp Area").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            HStack{
                                Text(campArea.name)
                                Spacer()
                            }.padding()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("City").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            HStack{
                                Text(campArea.city)
                                Text(city)
                                Spacer()
                            }.padding()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("Location").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            HStack{
                                Button {
                                    OpenWithMaps(latitude: campArea.lat, longitude: campArea.lon)
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("\(campArea.lat)")
                                        Spacer()
                                        Text("\(campArea.lon)")
                                        Spacer()
                                    
                                    }
                                }

                            }.padding()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("Adress").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            HStack{
                                Text(campArea.adress)
                                Spacer()
                            }.padding()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("Information").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            VStack{
                                Text(campArea.info).lineLimit(5)
                                Text(status)
                                Text("\(statusCode)")
                                Text("\(hummudity)")
                                Text("\(((temperature)/10))")
                                
                                
                               
                            }.padding()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("Abilities").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
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
                        }
                        VStack{
                            HStack{
                                Spacer()
                                Text("Added By").bold()
                                Spacer()
                            }
                            .padding()
                            .background(Color(.init(gray: 0.3, alpha: 0.2)))
                            HStack{
                                Text(campArea.createdUser)
                            }.padding()
                        }
                        
                        Group {
                            VStack{
                                HStack{
                                    Spacer()
                                    Button(role: .destructive) {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text("Cancel").bold()
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.init(gray: 0.3, alpha: 0.2)))
                               
                            }
                            if manager.selectedArea.createdUser == userManager.CampUser.email {
                                VStack{
                                    HStack{
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
                            } else {
                                EmptyView()
                            }
                            
                        }
                       
                    }
                }
                Group{
                    Button {
                        showComments.toggle()
                        
                    } label: {
                       Text("Show Comments")
                       
                    }
                }
            }
        }
        .onAppear(){
            manager.GetAreaComments(id: campArea.id)
            manager.getAreaWeather(longitute: manager.selectedArea.lon, latitute: manager.selectedArea.lat) { model in
                city = model.name
                temperature = model.main.feels_like ?? 0
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

func OpenWithMaps(latitude : Double, longitude: Double)
{
    let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
    if UIApplication.shared.canOpenURL(url!) {
          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    else{
          let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
                    
           UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
    }
}

struct CampAreaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CampAreaDetailView(campArea: CampingArea(id: "", name: "bak",lat: 0.0 ,lon: 0.0, city: "", adress: "",telephone: "0"),manager: CampingAreaManager(),userManager: UserManager())
    }
}
