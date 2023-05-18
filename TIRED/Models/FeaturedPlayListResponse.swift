//
//  FeaturedPlayListResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

struct FeaturedPlayListsResponse:Codable {
    let playlists:PlaylistResponse
    
    
}
struct CategoryPlayListsResponse:Codable {
    let playlists:PlaylistResponse
    
    
}

struct PlaylistResponse:Codable {
    let items:[Playlist]
}




struct User:Codable {
    let display_name:String
    let external_urls:[String:String]
    let id:String
    
}



