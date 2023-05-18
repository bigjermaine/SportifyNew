//
//  Artist.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

struct Artist:Codable {
    let id:String
    let name:String
    let type:String
    let images:[ApiImage]?
    let external_urls:[String:String]
        
}








