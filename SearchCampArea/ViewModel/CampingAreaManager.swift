//
//  CampingAreaManager.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.05.2022.
//

import Foundation
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import FirebaseStorage
class CampingAreaManager: NSObject, ObservableObject , CLLocationManagerDelegate
{
    @Published var locationManager = CLLocationManager()
    @Published var location = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    @Published var mapRect = MKMapRect()
    @Published var CampingArray = [CampingArea]()
    @Published var Region = MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
                                               , span: MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @Published var lastCampAreas = [CampingArea]()
    @Published var area = CampingArea()
    @Published var selectedArea = CampingArea()
    @Published var searchedAreas = [CampingArea]()
    @Published var comments = [Comments]()
    @Published var addingAlert = false
    @Published var addingAlertText = ""
    @Published var userCreatedAreas = [CampingArea]()
   
    //weather api ket
    private let APIKey = "9b7e5ffbf0e0647bfe0a3e38636639ac"
    let db = Firestore.firestore()
    
    
    override init() {
        
       
        super.init()
        checkManager()
        getCampAreas()
   
    }
    
    func fit()
    {
       // let points = CampingArray.map(\).map(MKMapPoint.init)
       //        mapRect = points.reduce(MKMapRect.null) { rect, point in
       //            let newRect = MKMapRect(origin: point, size: MKMapSize())
       //            return rect.union(newRect)
       //        }
    }
    
    func checkManager()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = .leastNormalMagnitude
            locationManager.delegate = self
            checkLocationAuth()
           
        }
        else
        {
           addLog(log: "CLLocation is not enabled", name: "checkManager")
        }
    }

    
    /// check location auth
    func checkLocationAuth()
    {

        switch locationManager.authorizationStatus{
        case .notDetermined:
            addLog(log: "location auth not determined", name: "checkLocationManager")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            addLog(log: "location auth restricted", name: "checkLocationManager")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            addLog(log: "location auth denied", name: "checkLocationManager")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            Region.center.longitude = (locationManager.location?.coordinate.longitude)!
            Region.center.latitude = (locationManager.location?.coordinate.latitude)!
        case.authorizedAlways:
            Region.center.longitude = (locationManager.location?.coordinate.longitude)!
            Region.center.latitude = (locationManager.location?.coordinate.latitude)!
        @unknown default:
            break
        }
    }
    
    /// Add camp area picture
    /// - Parameters:
    ///   - area: area model
    ///   - pickerData: image picker data
    func AddCampAreaImage(area : CampingArea ,pickerData : Data?)
    {
        let ref = Storage.storage().reference(withPath: area.id)
        guard let imageData = pickerData
        else{
            self.addNewCampArea(area: area, picLink: "")
            addLog(log: "image data is empty", name: "AddCampAreaImage")
            return
            
        }
        ref.putData(imageData, metadata: nil) { StorageData, error in
            if let error = error {
                self.addingAlertText = error.localizedDescription
                self.addingAlert = true
                self.addLog(log: self.addingAlertText, name: "AddCampAreaImage")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    self.addingAlertText = error.localizedDescription
                    self.addingAlert = true
                    self.addLog(log: self.addingAlertText, name: "AddCampAreaImage")
                    return
                }
                //self.InfoText = "succes to download"
                let imagePath = url?.absoluteString ?? ""
                self.addNewCampArea(area: area, picLink: imagePath)
                
            }
        }
    }
    
    /// add new area to firestore
    /// - Parameters:
    ///   - area: <#area description#>
    ///   - picLink: <#picLink description#>
    func addNewCampArea(area : CampingArea,picLink : String)
    {
        let data = [
            "id": UUID().uuidString,
            "city" : area.city.lowercased(),
            "lat" : area.lat,
            "lon" : area.lon,
            "name" : area.name,
            "telephone" : area.telephone,
            "adress" : area.adress,
            "charge" : area.charge,
            "createdUser" : area.createdUser,
            "internet" : area.internet,
            "provided" : area.provided,
            "restaurant" : area.restaurant,
            "water" : area.water,
            "wc" : area.wc,
            "info" : area.info,
            "createdDate" : Date.now,
            "picLink" : picLink
        ] as [String : Any]
        
        db.collection("Camp").addDocument(data: data) { error in
            if let err = error {
                self.addLog(log: err.localizedDescription, name: "addNewCampArea")
                self.addingAlertText = err.localizedDescription
                self.addingAlert = true
            }
            else
            {
                self.CampingArray.append(area)
                self.getCampAreas()

            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkManager()
    }
    
    /// get camp areas from firestore
    func getCampAreas()
    {
        self.CampingArray.removeAll()
        db.collection("Camp").getDocuments { snap, error in
            if let error = error {
                self.addLog(log: error.localizedDescription, name: "getCampAreas")
                return
            }
            else
            {
                for doc in snap!.documents{
                    do{
                        let area = try doc.data(as: CampingArea.self)
                        self.CampingArray.append(area)
                        
                    }
                    catch{
                        self.addLog(log: error.localizedDescription, name: "getCampAreas")
                    }
                  
                }
            }
        }
    }
    
    func AddAreaComment(campid : String,userid : String, comment : String)
    {
        let data = [
            "id" : UUID().uuidString,
            "comment" : comment,
            "campAreaId" : campid,
            "userId" : userid,
            "commentDate" : Date.now
        ] as [String : Any]
        
        db.collection("Comments").addDocument(data: data) { error in
            if let err = error {
                self.addLog(log: err.localizedDescription, name: "AddAreaComment")
            }
            else
            {
                self.addLog(log: "comment added", name: "AddAreaComment")
                self.comments.append(Comments(id: UUID().uuidString, comment: comment, campAreaId: campid, userId: userid, commentDate: Date.now))
            }
        }
    }
    
    func GetAreaComments(id : String)
    {
        self.comments.removeAll()
        db.collection("Comments").whereField("campAreaId", isEqualTo: id ).order(by: "commentDate", descending: true) .getDocuments { snap, error in
            if let err = error{

                self.addLog(log: err.localizedDescription, name: "GetAreaComments")
            }
            else
            {
                for doc in snap!.documents
                {
                    do{
                        let comment = try doc.data(as: Comments.self)
                        self.comments.append(comment)
                    }
                    catch{
                        self.addLog(log: error.localizedDescription, name: "GetAreaComments")
                    }
                }
            }
        }
    }
    
    func getLastTenAreas()
    {
        self.lastCampAreas.removeAll()
        db.collection("Camp").order(by: "createdDate", descending: true).limit(to: 10).getDocuments { snap, error in
            if let err = error{
                self.addLog(log: err.localizedDescription, name: "getLastTenAreas")
            }
            else
            {
                for doc in snap!.documents
                {
                    do{
                        let area = try doc.data(as: CampingArea.self)
                        self.lastCampAreas.append(area)
                    }
                    catch{
                        self.addLog(log: error.localizedDescription, name: "getLastTenAreas")
                    }
                }
            }
        }
    }
    
    func getAreaWithSearch(city : String, water : Bool, wc : Bool,restaurant : Bool,searchByField : Bool)
    {
        self.searchedAreas.removeAll()
        if searchByField
        {
          
            if city != ""
            {
                let ref = db.collection("Camp").whereField("city", isEqualTo: city.lowercased()).whereField("water", isEqualTo: water).whereField("wc", isEqualTo: wc).whereField("restaurant", isEqualTo: restaurant).order(by: "createdDate", descending: true)
                ref.getDocuments { snap, error in
                    if let err = error{
                        self.addLog(log: err.localizedDescription, name: "Get Camp Areas")
                    }
                    else
                    {
                        for doc in snap!.documents
                        {
                            do{
                                let area = try doc.data(as: CampingArea.self)
                                self.searchedAreas.append(area)
                            }
                            catch{
                                self.addLog(log: error.localizedDescription, name: "Get Camp Areas")
                            }
                        }
                    }
                }
            }
            else
            {
                let ref = db.collection("Camp").whereField("water", isEqualTo: water).whereField("wc", isEqualTo: wc).whereField("restaurant", isEqualTo: restaurant).order(by: "createdDate", descending: true)
                ref.getDocuments { snap, err in
                    if let err = err{
                        self.addLog(log: err.localizedDescription, name: "Get Camp Areas")
                    }
                    else
                    {
                        for doc in snap!.documents
                        {
                            do{
                                let area = try doc.data(as: CampingArea.self)
                                self.searchedAreas.append(area)
                            }
                            catch{
                                self.addLog(log: error.localizedDescription, name: "Get Camp Areas")
                            }
                        }
                    }
                }
            }
           
            
        }
        else
        {
                db.collection("Camp").limit(to: 20).getDocuments { snap, error in
                    if let err = error{
                        self.addLog(log: err.localizedDescription, name: "Get Camp Areas")
                    }
                    else {
                        do{
                            for doc in snap!.documents
                            {
                                let area = try doc.data(as: CampingArea.self)
                                self.searchedAreas.append(area)
                            }
                            
                        }catch{
                            self.addLog(log: error.localizedDescription, name: "Get Camp Areas")
                        }
                    }
               
                
            }
        }
        
        
    }
    
    func getUserAreas(email : String)
    {
        self.userCreatedAreas.removeAll()
        db.collection("Camp").whereField("createdUser", isEqualTo: email).getDocuments { snap, error in
           if let er = error
            {
               self.addLog(log: er.localizedDescription, name: "getUserAreas")
           }
            else
            {
                for doc in snap!.documents
                {
                    do{
                        let area = try doc.data(as: CampingArea.self)
                        self.userCreatedAreas.append(area)
                    }
                    catch{
                        self.addLog(log: error.localizedDescription, name: "getUserAreas")
                    }
                }
            }
            
        }
    }
    
    func deleteCampArea(id : String)
    {
        db.collection("Camp").whereField("id", isEqualTo: id).getDocuments { snap, err in
            
            let ref = snap?.documents.first?.documentID
            self.db.collection("Camp").document(ref!).delete { err in
                self.addLog(log: err?.localizedDescription ?? "Delete Error", name: "Delete Error")
            }
        }
        self.getCampAreas()
        self.getLastTenAreas()
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

    func GetUserAreas(user : User)
    {
        
        
        self.userCreatedAreas.removeAll()
        db.collection("Camp").whereField("createdUser", isEqualTo: user.email).getDocuments { querySnapshot, error in
            if let err = error
            {
                self.addLog(log: err.localizedDescription, name: "GetUserAreas")
            }
            else
            {
                for doc in querySnapshot!.documents
                {
                    do{
                        
                        let area = try doc.data(as: CampingArea.self)
                        self.userCreatedAreas.append(area)
                        
                    }
                    catch
                    {
                        self.addLog(log: error.localizedDescription, name: "GetUserAreas")
                    }
                }
            }
        }
        
    }
    
    func getAreaWeather(longitute : Double, latitute : Double, completion:@escaping (WeatherModel) -> ()) {
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(format: "%.1f", latitute/1))&lon=\(String(format: "%.1f", longitute/1))&appid=\(APIKey)") else {
                print("Invalid url...")
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                do{
                    let currentWeather = try! JSONDecoder().decode(WeatherModel.self, from: data!)
                    DispatchQueue.main.async {
                        completion(currentWeather)
                    }
                }
                catch
                {
                    print("weather error",error.localizedDescription)
                }
                
               
                //print(currentWeather)
        
            }.resume()
            
        }
    

}


