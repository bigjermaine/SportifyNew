//
//  PlaylistResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//
import Foundation


struct  PlaylistDetailsResponse:Codable {
    let description:String
    let external_urls:[String:String]
    let id:String
    let images:[ApiImage]
    let name:String
    let tracks:PlayTracksResponse
    
}

struct PlayTracksResponse:Codable {
    let items:[PlaylistItem]
}

struct PlaylistItem:Codable {
    let track:AudioTrack
}


struct CategoryCollectionViewCellViewModel:Codable {
    let title:String
    let artworkURL:URL?
}
