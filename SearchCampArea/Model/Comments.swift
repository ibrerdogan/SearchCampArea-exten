//
//  Comments.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 15.06.2022.
//

import Foundation

struct Comments : Identifiable , Codable{
    var id = UUID().uuidString
    var comment : String
    var campAreaId = UUID().uuidString
    var userId = UUID().uuidString
    var commentDate : Date
}
