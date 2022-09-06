//
//  Extensions.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 6.09.2022.
//

import Foundation
import SwiftUI

extension View
{
    func BoardingViewTextField(opacity : CGFloat) -> some View
    {
        modifier(BoardingTextFieldsModifier(opacity: opacity))
    }
    
    func AddCampAreaButton() -> some View
    {
        modifier(AddCampAreaButtonModifier())
    }
    func UrlImage() -> some View
    {
        modifier(URLImageModifier())
    }
    func ProfileImage() -> some View
    {
        modifier(ProfileImageModifier())
    }
}
