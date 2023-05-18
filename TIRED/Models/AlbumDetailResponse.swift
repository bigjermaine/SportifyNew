//
//  AlbumDetailResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation


struct AlbumDetailsResponse:Codable {
    let album_type:String
    let artists:[Artist]
    let available_markets:[String]
    let external_urls:[String:String]
    let id:String
    let images:[ApiImage]
    let label:String
    let name:String
    let tracks:TracksResponse

}

struct TracksResponse:Codable {
    let items:[AudioTrack]
}
