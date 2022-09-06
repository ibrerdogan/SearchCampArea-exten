//
//  AddCampingAreaFormView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 22.06.2022.
//

import SwiftUI

struct AddCampingAreaFormView: View {
    @ObservedObject var manager : CampingAreaManager
    @Environment(\.presentationMode) var presentationMode
    @State var showPicker = false
    @State var picker : UIImage?
    var userMail : String
    @State var city = ""
    var body: some View {
        Form
        {
            Section {
                HStack(spacing : 12)
                {
                    Text("Area Named : ")
                    TextField("Name", text: $manager.area.name)
                }
                HStack(spacing : 12)
                {
                    Text("City : ")
                    TextField("City", text: $manager.area.city)
                }
                HStack(spacing : 12)
                {
                    Text("Adress : ")
                    TextField("Adress", text: $manager.area.adress)
                }
                HStack(spacing : 12)
                {
                    Text("\(manager.Region.center.latitude)")
                    Text("\(manager.Region.center.longitude)")
                   
                }
            } header: {
                Text("Area Informations")
            }
            
            Section {
               
                HStack(spacing : 12)
                {
                    CheckBoxView(callback: internetCallBack, check: manager.area.internet, text: "Internet Connection")
                }
                HStack(spacing : 12)
                {
                    CheckBoxView(callback: WcCallBack, check: manager.area.wc, text: "Wc And Shower")
                }
                HStack(spacing : 12)
                {
                    CheckBoxView(callback: MarketCallBack, check: manager.area.water, text: "Market or Shop")
                }
                HStack(spacing : 12)
                {
                    CheckBoxView(callback: RestaurantCallBack, check: manager.area.restaurant, text: "Restaurant")
                }
                HStack(spacing : 12)
                {
                    Text("Charge : ")
                    TextField("Charge", value: $manager.area.charge,formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
            } header: {
                Text("Oppurtunities")
            }
            
            Section{
                TextEditor(text: $manager.area.info)
                    .lineLimit(5)
            }header: {
                Text("Additional Information")
            }
            
            Button {
                showPicker.toggle()
            } label: {
                HStack{
                    Image(systemName: "plus")
                    Text("Add Photo")
                }
            }

            
            Button {
                manager.area.lat = manager.locationManager.location?.coordinate.latitude ?? 20.0
                manager.area.lon = manager.locationManager.location?.coordinate.longitude ?? 20.0
                //manager.area.lat = manager.Region.center.latitude
                //manager.area.lon = manager.Region.center.longitude
                manager.area.createdUser = userMail
                manager.AddCampAreaImage(area: manager.area, pickerData: picker?.jpegData(compressionQuality: 0.5))
                //manager.addNewCampArea(area: manager.area)
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Image(systemName: "plus")
                    Text("Add New Location")
                }
            }
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack{
                    Image(systemName: "multiply.circle")
                    Text("Close")
                }
            }


        }
        .onAppear(){
            manager.getAreaWeather(longitute: manager.Region.center.longitude, latitute: manager.Region.center.latitude) { model in
                manager.area.city = model.name
            }
        }
        .fullScreenCover(isPresented: $showPicker) {
            ImagePicker(image: $picker)
        }
        .alert(manager.addingAlertText, isPresented: $manager.addingAlert) {
            Button {
                manager.addingAlertText = ""
            } label: {
                Text("OK")
            }

        }
    }
    
    func internetCallBack(check : Bool) -> ()
    {
        manager.area.internet = check
    }
    func WcCallBack(check : Bool) -> ()
    {
        manager.area.wc = check
    }
    func MarketCallBack(check : Bool) -> ()
    {
        manager.area.water = check
    }
    func RestaurantCallBack(check : Bool) -> ()
    {
        manager.area.restaurant = check
    }
}

struct AddCampingAreaFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddCampingAreaFormView(manager: CampingAreaManager(),userMail: "")
    }
}
/**

 */
