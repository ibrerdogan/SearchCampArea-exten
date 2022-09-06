//
//  CampingAreaModel.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 23.05.2022.
//

import Foundation
import CoreLocation
import MapKit
struct CampingArea : Identifiable , Codable
{
    var id = UUID().uuidString
    var name : String = ""
    //var coordinate : CLLocationCoordinate2D
    var lat : Double = 0
    var lon : Double = 0
    var city : String = ""
    var adress : String = ""
    var telephone : String = ""
    var charge : Double = 0
    var createdUser : String = ""
    var internet : Bool = false
    var provided : Bool = false
    var restaurant : Bool = false
    var water : Bool = false
    var wc : Bool = false
    var info : String = ""
    var createdDate : Date = Date.now
    var picLink : String = ""
    
   
    
    
}
