//
//  BoardingView.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 15.06.2022.
//

import SwiftUI

struct BoardingView: View {
    @State var email = ""
    @State var password = ""
    @State var opacity = 0.0
    @State var bg_opacity = 1.0
    @State var signup = false
    @ObservedObject var userManager = UserManager()
    @ObservedObject var campingAreaManager = CampingAreaManager()
    
    
    var body: some View {
        VStack{
            Image("Image")
                .resizable()
                .opacity(bg_opacity)
                .overlay {
                    if userManager.processing {
                        VStack{
                            VStack{
                                Text("Search Camp Area")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .opacity(opacity)
                            }
                            Text(userManager.InfoText).bold().foregroundColor(.accentColor)
                            Text(userManager.ErrorText).bold().foregroundColor(.red)
                            
                            TextField("e-mail",text: $email)
                                .BoardingViewTextField(opacity: opacity)
                            SecureField("Password",text: $password)
                                .BoardingViewTextField(opacity: opacity)
                            Button {
                                if signup {
                                    userManager.processing.toggle()
                                    userManager.AddNewUser(email: email, password: password)
                                }
                                else{
                                    userManager.processing.toggle()
                                    userManager.UserLogin(email: email, password: password)
                                }
                            } label: {
                                VStack
                                {
                                    Rectangle().frame(width: 200, height: 40, alignment: .center)
                                        .cornerRadius(30)
                                        .opacity(opacity)
                                        .overlay {
                                            Text(signup ? "Sign-Up" : "Sign-In").foregroundColor(.white).opacity(opacity)
                                            
                                        }
                                }
                            }
                            Button {
                                signup.toggle()
                            } label: {
                                Text(signup ? "You Have Already An Account" : "If You Are Not a Member").bold()
                                    .opacity(opacity)
                            }

                        }
                        .padding()
                    } else {
                        VStack{
                            VStack
                            {
                                ProgressView()
                            }
                            
                        }
                    }
                  
                }
        }.ignoresSafeArea()
            .fullScreenCover(isPresented: $userManager.getUserInfoDone , content: {
                ContentView(manager: userManager,campingAreaManager: campingAreaManager)
            })
            .fullScreenCover(isPresented: $userManager.addNewUser, content: {
                ContentView(tabIndex: 2, manager: userManager,campingAreaManager: campingAreaManager)
            })
            .alert(userManager.ErrorText, isPresented: $userManager.errorRaised, actions: {
                Button(role: .destructive) {
                    userManager.ErrorText = ""
                } label: {
                    Text("OK")
                }

            })
            .onAppear {
                userManager.CheckInternetConnection()
                userManager.ClearAllFiels()
                userManager.CheckCurrentUser()
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation{
                        opacity = 0.9
                        bg_opacity = 0.4
                    }
                   
                }
            }
    }
}

struct BoardingView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView()
    }
}

