//
//  SearchResult.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

enum SearchResult {
    case artist(model:Artist)
    case album(model:Album)
    case track(model:AudioTrack)
    case playlist(model:Playlist)
    
}
