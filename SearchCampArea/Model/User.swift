//
//  User.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 15.06.2022.
//

import Foundation

struct User : Codable, Identifiable
{
    var id = UUID().uuidString
    var name : String
    var surname : String
    var email : String
    var profilepic : String
    
    init(name : String?, surname : String?, email : String?,profilepic : String?)
    {
        self.name = name ?? ""
        self.surname = surname ?? ""
        self.email = email ?? ""
        self.profilepic = profilepic ?? ""
    }
}
