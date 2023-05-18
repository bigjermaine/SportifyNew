//
//  Settings.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation



struct Section {
    let title:String
    let options:[Option]
    
}
struct Option {
    let title:String
    let handler:() -> Void
}
