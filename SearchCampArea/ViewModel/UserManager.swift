//
//  UserManager.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 15.06.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseStorage
import Network
class UserManager : ObservableObject
{
    @Published var CampUser = User(name: "", surname: "",email: "",profilepic: "")
    @Published var InfoText = ""
    @Published var ErrorText = ""
    @Published var addNewUser = false // add new user
    @Published var processing = true //show 
    @Published var addingDone = false //new user created
    @Published var addImageAndInfoToFirestore = false // user pic and infos save to firestre
    @Published var getUserInfoDone = false // get user info
    @Published var updateError = false
    @Published var errorRaised = false
    let monitor = NWPathMonitor()
    @Published private(set) var connected: Bool = false
    
    
    let auth = FirebaseAuth.Auth.auth()
    let db = Firestore.firestore()
    
    /// For add new user to firebase authentication
    /// - Parameters:
    ///   - email:
    ///   - password: 
    func AddNewUser(email : String, password : String)
    {
        self.ErrorText = ""
        self.InfoText = ""
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                self.ErrorText = error.localizedDescription
                self.processing = true
                self.errorRaised = true
                self.addLog(log: error.localizedDescription, name: "AddNewUser")
                return
            }
            else
            {
                self.InfoText = "User Created For \(result?.user.email ?? "")"
                self.CampUser.email = result?.user.email ?? ""
                self.InsertNewUserToFirestore(user: self.CampUser, profilePic: "")
                self.addNewUser = true
            }
        }
    }
    
    
    /// save user profile pic to firestore
    /// - Parameters:
    ///   - user: get current user
    ///   - pickerData: image picker data
    func AddImageToFirestore(user : User , pickerData : Data?)
    {
        let ref = Storage.storage().reference(withPath: user.email)
        guard let imageData = pickerData
        else{
            self.InsertNewUserToFirestore(user : user ,profilePic: "empty")
            self.addLog(log: "Empty PickerData", name: "AddImageToFirestore")
            return
            
        }
        ref.putData(imageData, metadata: nil) { StorageData, error in
            if let error = error {
                self.ErrorText = error.localizedDescription
                self.updateError = true
                self.addLog(log: error.localizedDescription, name: "AddImageToFirestore")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    self.ErrorText = error.localizedDescription
                    self.updateError = true
                    self.addLog(log: error.localizedDescription, name: "AddImageToFirestore")
                    return
                }
                //self.InfoText = "succes to download"
                let imagePath = url?.absoluteString ?? ""
                self.InsertNewUserToFirestore(user : user ,profilePic: imagePath)
            }
        }
    }
    
    /// user login check login information
    /// - Parameters:
    ///   - email: email description
    ///   - password: password description
    func UserLogin(email : String , password : String)
    {
        self.ErrorText = ""
        self.InfoText = ""
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.ErrorText = error.localizedDescription
                self.processing = true
                self.errorRaised = true
                self.addLog(log: error.localizedDescription, name: "UserLogin \(email)")
                return
            }
            else
            {
                self.InfoText = "User Signed"
                self.CampUser.email = result?.user.email ?? ""
                self.getUserinfo(email:  self.CampUser.email)
                
            }
        }
    }
    
    /// checking user is loggin or not
    func CheckCurrentUser()
    {
        self.ErrorText = ""
        self.InfoText = ""
        let email = auth.currentUser?.email ?? ""
        
        if email != ""
        {
            self.InfoText = "Current User \(email)"
            getUserinfo(email: email)
            
           
        }
        else
        {
            self.processing = true
        }
    }
    
    
    /// get user additional information from user table
    /// - Parameter email: current user email
    func getUserinfo(email : String)
    {
        db.collection("Users").document(email).getDocument { snap, error in
            if let err = error{
                self.addLog(log: err.localizedDescription, name: "getUserinfo")
                self.errorRaised = true
                self.ErrorText = err.localizedDescription
            }
            else
            {
                do{
                    self.CampUser = try snap!.data(as: User.self)
                    self.getUserInfoDone = true
                }
                catch{
                    self.errorRaised = true
                    self.ErrorText = error.localizedDescription
                    self.addLog(log: self.ErrorText, name: "getUserinfo")
                }
            }
        }
    }
    
    func getUserNameById( id : String) -> String
    {
        var name = ""
        db.collection("Users").whereField("id", isEqualTo: id).getDocuments { snap, error in
            if let err = error {
                print(err.localizedDescription)
                
            }
            else
            {
                do{
                    let user = try snap?.documents.first?.data(as: User.self)
                    name = user!.email
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
        return name
        
    }
    
    
    func SignOut()
    {
        do{
            CampUser.profilepic = ""
            CampUser.surname = ""
            CampUser.name = ""
            CampUser.email = ""
            self.processing = true
           try auth.signOut()
        }
        catch{
            self.addLog(log: error.localizedDescription, name: "SignOut")
        }
    }
    
    /// create new user table on firestore. NOTE: if profile pic is emty this function only for update user info
    /// - Parameters:
    ///   - user: current user
    ///   - profilePic: picture url
    func InsertNewUserToFirestore(user : User,profilePic : String)
    {
        self.InfoText = "Default infos are creating \(user.email)"
        CampUser.name = user.name
        CampUser.email = user.email
        CampUser.surname = user.surname
        var pic = ""
        if profilePic != "empty"
        {
            CampUser.profilepic = profilePic
            pic = profilePic
        }
        else
        {
            pic = CampUser.profilepic
        }
        
        let Data = [
            "id" : UUID().uuidString,
            "email" : user.email,
            "name" : user.name,
            "surname" : user.surname,
            "profilepic" : pic
        ] as [String : Any]
        
        db.collection("Users").document(user.email).setData(Data) { error in
            guard error == nil else {
                self.ErrorText = error?.localizedDescription ?? "update user info fault"
                self.updateError = true
                self.errorRaised = true
                self.addLog(log: self.ErrorText, name: "InsertNewUserToFirestore")
                return
            }
            self.addImageAndInfoToFirestore = true
        }
    }
    
    func ClearAllFiels()
    {
        self.ErrorText = ""
        self.InfoText = ""
        self.CampUser = CampUser
    }
    
    func addLog(log : String, name : String)
    {
        let data = [
            "log" : log,
            "func" : name,
            "date" : Date.now
        ] as [String : Any]
        
        db.collection("Logs").addDocument(data: data)
    }
    
    func CheckInternetConnection()
    {
        monitor.pathUpdateHandler = { path in
               if path.status == .satisfied {
                    self.connected = true
               } else {
                    self.connected = false
                    self.ErrorText = "No Internet"
                    self.errorRaised = true
                   
               }
           }
    }

}

