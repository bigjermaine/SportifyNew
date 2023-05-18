//
//  Playlist.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

struct Playlist:Codable {
    let description:String
    let external_urls:[String:String]
    let id:String
    let images:[ApiImage]
    let name:String
    let owner:User
}
