//
//  SearxhResultResponse.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

struct SearchResultResponse:Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistResponse
    let playlists: SearchPlaylistResponse
    let tracks:SearchTracksResponse
    

}

struct SearchAlbumResponse:Codable {
    let items:[Album]
}

struct SearchArtistResponse:Codable {
    let items:[Artist]
}

struct SearchPlaylistResponse:Codable {
    let items:[Playlist]
}

struct SearchTracksResponse:Codable {
    let items:[AudioTrack]
    
}
