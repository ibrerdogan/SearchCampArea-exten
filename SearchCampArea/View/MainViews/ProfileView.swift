//
//  ProfileView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 24.05.2022.
//

import SwiftUI
import URLImage

struct ProfileView: View {
    var creationOrUpdate : Bool
    @ObservedObject var userManager : UserManager
    @ObservedObject var campingAreaManager : CampingAreaManager
    @State var picker : UIImage?
    @State var imagePath = ""
    @State var showPicker = false
    @Environment(\.presentationMode) var presentationMode
    @State var displayCampAreaDetail = false
    var body: some View {
        
        VStack {
            VStack
            {
                if userManager.CampUser.profilepic != ""
                {
                    URLImage(URL(string: userManager.CampUser.profilepic)!,
                             empty: {
                            Image(systemName: "person.fill")
                            .UrlImage()
                             },
                             inProgress: { progress in
                                ProgressView().progressViewStyle(.automatic)
                             },
                             failure: { error, retry in
                            Image(systemName: "person.fill")
                            .UrlImage()
                             },
                             content: { image, info in
                                image
                            .resizable()
                            .ProfileImage()
                                    })

                }
                else{
                    if let image = self.picker{
                        Image(uiImage: image)
                            .resizable()
                            .ProfileImage()
                  
                    }
                   else
                    {
                       Image("Image-1")
                           .resizable()
                           .ProfileImage()
                    }
                }
               
                    
            }
            .padding()
            .shadow(color: .black, radius: 4, x: 2, y: 2)
        
            Form{
                Section {
                    TextField("Name", text: $userManager.CampUser.name)
                    TextField("Surname", text: $userManager.CampUser.surname)
                    Button {
                        showPicker.toggle()
                    } label: {
                        Text("Change Profile Pic")
                    }
                } header: {
                    Text("User Info")
                }
                
                Section{
                    Button {
                        userManager.AddImageToFirestore(user: userManager.CampUser, pickerData: picker?.jpegData(compressionQuality: 0.5))
                    } label: {
                        HStack{
                            Spacer()
                            if showPicker {
                                Text("Save Changes")
                                    .padding()
                            } else {
                                Text("Save Changes")
                                    .padding()
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack(alignment:.center){
                    Text("Your Areas").font(.title2)
                    HStack{
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(campingAreaManager.userCreatedAreas){camp in
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
                
                if creationOrUpdate != false {
                    Section{
                        Button(role: .destructive) {
                            userManager.SignOut()
                            presentationMode.wrappedValue.dismiss()
                            print("Quit")
                        } label: {
                            HStack{
                                Spacer()
                                Text("Quit").bold()
                                Spacer()
                            }
                        }

                    }
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear(){
            campingAreaManager.GetUserAreas(user: userManager.CampUser)
        }
        .fullScreenCover(isPresented: $displayCampAreaDetail) {
            CampDetailFormView(campArea: campingAreaManager.selectedArea,manager: campingAreaManager,userManager: userManager)
        }
        .fullScreenCover(isPresented: $showPicker) {
            ImagePicker(image: $picker)
        }

        .alert(userManager.ErrorText, isPresented: $userManager.updateError) {
            Button(role: .cancel) {
                userManager.updateError = false
            } label: {
                Text("Cancel")
            }

        }
        .alert("Updated", isPresented: $userManager.addImageAndInfoToFirestore) {
            Button(role: .cancel) {
                userManager.addImageAndInfoToFirestore = false
            } label: {
                Text("Updated Succesfuly")
            }

        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(creationOrUpdate: false,userManager: UserManager(),campingAreaManager: CampingAreaManager())
    }
}
